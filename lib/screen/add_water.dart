import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/all_connect.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../css/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application/model/addressAPI.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/src/source.dart' as source;

class AddWaterScreen extends StatefulWidget {
  final List<Profile> userData;
  const AddWaterScreen({super.key, required this.userData});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _descriptionController = TextEditingController();

  //date time
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  // final date = DateTime.now();

  Timer? timer; //ตั้งค่าเวลา Loop
  // Timer(Duration)
  late Future<Address> futureAddress;
  @override
  void initState() {
    _handleLocationPermission();
    futureAddress = fetchAddress();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      futureAddress = fetchAddress();
    });
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  //ตรวจสอบการเปิดใช้งาน Location
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("บริการระบุตำแหน่งถูกปิดใช้งาน กรุณาเปิดใช้บริการ");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("การอนุญาตเข้าถึงตำแหน่งถูกปฏิเสธ");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log("การอนุญาตเข้าถึงตำแหน่งถูกปฏิเสธอย่างถาวร เราไม่สามารถขอสิทธิ์ได้");
      return false;
    }
    log("ได้รับการอนุญาตการเข้าถึงตำแหน่ง");
    return true;
  }

  //new
  late Position position;
  double? latitude;
  double? longitude;
  double? altitude;
  double? accuracy;
  late int timeSatellite;

  double? cutAccuracy;
  double? cutAltitude;

  double toPrecision(double input, int n) {
    return double.parse(input.toStringAsFixed(n));
  }

  String? province;
  String? district;
  String? subdistrict;
  String? postcode;
  String? selectWaterType;
  String? statusText;
  Widget? textStatus;
  bool isLoadingStatus = false;

  Future<Address> fetchAddress() async {
    //หาค่า Latitude, Longitude
    // await _handleLocationPermission();
    //หาค่าตำแหน่งที่อยู่
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    isLoadingStatus = true;

    if (mounted) {
      setState(() {
        accuracy = position.accuracy;
        latitude = position.latitude;
        longitude = position.longitude;
        altitude = position.altitude;

        cutAccuracy = toPrecision(accuracy!, 4);
        cutAltitude = toPrecision(altitude!, 6);

        if (cutAccuracy! <= 0.04 && cutAccuracy! != 0.00) {
          statusText = "ความแม่นยำสูง";
          textStatus = const Text(
            "ความแม่นยำสูง",
            style: StyleFontStatusReady,
          );
        } else {
          statusText = "ความแม่นยำต่ำ";
          textStatus = const Text(
            "ความแม่นยำต่ำ",
            style: StyleFontStatusNotReady,
          );
        }
      });
    }
    if (!mounted) {
      timer?.cancel();
    }

    timeSatellite = position.timestamp.millisecondsSinceEpoch;
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timeSatellite);
    int yearBuddhist = tsdate.year + 543;
    String dateCurrent =
        DateFormat('dd MMMM $yearBuddhist hh:mm:ss').format(tsdate);
    // DateFormat formatter = DateFormat.yMMMd();

    debugPrint("accuracy= $cutAccuracy");
    debugPrint("latitude= $latitude");
    debugPrint("longitude= $longitude");
    debugPrint("altitude= $cutAltitude");
    debugPrint("dateCurrent= $dateCurrent");
    debugPrint("timeSatellite= $timeSatellite");
    debugPrint("water type= $selectWaterType");

    String apiKey = "683f7860bae9af594726778cacb24232";
    final response = await http.get(Uri.parse(
        'https://api.longdo.com/map/services/address?lon=$longitude&lat=$latitude&key=$apiKey'));

    if (response.statusCode == 200) {
      log(response.body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      province = data['province'];
      district = data['district'];
      subdistrict = data['subdistrict'];
      postcode = data['postcode'];

      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load address');
    }
  }

  // *** FIREBASE ***
  // 1.เตรียม Firebase

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference addressCollection =
      FirebaseFirestore.instance.collection("addresses");

  Future saveLocationDetail() async {
    String? email;
    for (Profile data in widget.userData) {
      email = data.email;
    }

    String description = _descriptionController.text;
    final countAddress = await addressCollection.count().get();
    int totalAddress = countAddress.count;
    int itemNumber = totalAddress + 1;
    String? item;

    if (itemNumber.toString().length == 1) {
      item = '0000$itemNumber';
    } else if (itemNumber.toString().length == 2) {
      item = '000$itemNumber';
    } else if (itemNumber.toString().length == 3) {
      item = '00$itemNumber';
    } else if (itemNumber.toString().length == 4) {
      item = '0$itemNumber';
    } else {
      item = '$itemNumber';
    }
    log("number = $item");

    await addressCollection.add({
      "item": item,
      "added_by": email,
      "accuracy": cutAccuracy,
      "altitude": cutAltitude,
      "latitude": latitude,
      "longitude": longitude,
      "approve": "waiting",
      "subdistrict": subdistrict,
      "district": district,
      "province": province,
      "postcode": postcode,
      "timestamp": timestamp,
      "watertype": selectWaterType,
      "description": description,
    });
  }

  //เลือกรูป
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  File? file; //old
  // int numFile = 1;
  // List newName = [];

  Future getImageFromGallery() async {
    if (selectedImages.length < 5) {
      try {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);

        // File resultFile = File(pickedFile!.path);
        // File newFileResult = changeFileName(resultFile);
        // log(newFileResult.toString());
        // XFile newXFileResult = XFile(newFileResult.path);
        // print("1=$newXFileResult");
        // print("2=${newXFileResult.name}");

        setState(() {
          // //old
          // file = pickedFile;
          file = File(pickedFile!.path);
          selectedImages.add(file!);

          //new
          // selectedImages.add(pickedFile!);
          // selectedImages.add(newXFileResult);
          // numFile++;
        });

        debugPrint("List of Images = ${selectedImages.length}");
        if (pickedFile!.path.isEmpty) retrieveLostData();
      } catch (e) {
        debugPrint("Somthing Wrong. $e");
      }
    }
  }

  Future getImageFromCamera() async {
    if (selectedImages.length < 5) {
      try {
        pickedFile = await picker.pickImage(source: ImageSource.camera);

        setState(() {
          file = File(pickedFile!.path);
          selectedImages.add(file!);
        });

        debugPrint("List of Images = ${selectedImages.length}");
        if (pickedFile!.path.isEmpty) retrieveLostData();
      } catch (e) {
        debugPrint("Somthing Wrong. $e");
      }
    }
  }

  Future showOptionGetImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Photo Gallery"),
            onPressed: () {
              timer?.cancel();
              Navigator.of(context).pop();
              getImageFromGallery().whenComplete(() {
                timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  futureAddress = fetchAddress();
                });
              });
              // Navigator.of(context).pop();
              // getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Camera"),
            onPressed: () {
              timer?.cancel();
              Navigator.of(context).pop();
              getImageFromCamera().whenComplete(() {
                timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  futureAddress = fetchAddress();
                });
              });

              // Navigator.of(context).pop();
              // getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  deleteImage(data) {
    setState(() {
      selectedImages.remove(data);
      // newName.remove(data);
      // numFile--;
    });
    debugPrint("List of Images = ${selectedImages.length}");
  }

  Future<void> retrieveLostData() async {
    debugPrint("Here retrieveLostData");
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        file = File(pickedFile!.path);
        selectedImages.add(file!);

        //new
        // selectedImages.add(pickedFile!);
      });
    } else {
      debugPrint("${response.file}");
    }
  }

  // ***เตรียม Firebase Storage ***
  FirebaseStorage storageRef = FirebaseStorage.instance;
  double val = 0;
  List urlListPicture = [];
  late String id;

  Future uploadFile() async {
    int i = 1;
    if (selectedImages.isNotEmpty) {
      //บันทึกพิกัด
      await saveLocationDetail();
      //บันทึกรูปภาพ
      QuerySnapshot querySnapshot = await addressCollection
          .where('timestamp', isEqualTo: timestamp)
          .get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        id = document.id;
      }
      for (var img in selectedImages) {
        setState(() {
          val = i / selectedImages.length * 100;
        });
        Reference reference = storageRef
            .ref()
            .child("multiple_images")
            .child(timestamp.toString())
            .child("$timestamp-$i.jpg");
        UploadTask uploadTask =
            reference.putFile(img, SettableMetadata(contentType: "image/jpg"));
        String urlPicture = await (await uploadTask.whenComplete(() => null))
            .ref
            .getDownloadURL();
        debugPrint("urlPicture = $urlPicture");

        setState(() {
          urlListPicture.add(urlPicture);
        });

        // เพิ่มตัวแปร urlPicture เพื่อเก็บที่อยู่รูปภาพ
        await addressCollection.doc(id).update({
          "urlImage$i": urlPicture,
        });

        log("Percentage loading: ${val.toString()}");
        i++;
      }
    } else {
      log("Do not include a image");
      return Future.error("กรุณาใส่รูปภาพ");
    }
    selectedImages.clear();
    //บันทึกเสียง
    if (!isRemoveRecord && audioPath != null) {
      Reference reference = storageRef
          .ref()
          .child("multiple_audios")
          .child(timestamp.toString())
          .child("$timestamp.mp3");
      UploadTask uploadTask = reference.putFile(
          File(audioPath!), SettableMetadata(contentType: "audio/mpeg"));
      String urlAudio = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      debugPrint("urlAudio = $urlAudio");
      await addressCollection.doc(id).update({
        "urlAudio": urlAudio,
      });
    }
  }

  String? selectDropdown;
  List<String> dropdownList = [
    'เขื่อน',
    'อ่างเก็บน้ำ',
    'ตาน้ำ',
    'ทะเลสาบ/บ่อน้ำ',
    'หนอง/บึง',
    'แม่น้ำ/ลำน้ำ',
    'ปากน้ำ',
    'คลองชลประทาน',
  ];

  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String? audioPath;
  bool isPlayingRecord = false;
  bool isRemoveRecord = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      debugPrint("Error Start Recording : $e");
    }
  }

  Future stopRecording() async {
    try {
      String? path = await audioRecord.stop();

      setState(() {
        isRecording = false;
        audioPath = path!;
        isRemoveRecord = false;
      });
      log(audioPath!);
    } catch (e) {
      debugPrint("Error Stop Recording : $e");
    }
  }

  Future playRecording() async {
    try {
      source.Source urlSource = UrlSource(audioPath!);
      await audioPlayer.play(urlSource);

      setState(() {
        isPlayingRecord = true;
      });
      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          isPlayingRecord = false;
        });
      });
    } catch (e) {
      debugPrint("Error Playing Recording : $e");
    }
  }

  Future pauseRecording() async {
    try {
      await audioPlayer.pause();

      setState(() {
        isPlayingRecord = false;
      });
    } catch (e) {
      debugPrint("Error Pause Recording : $e");
    }
  }

  deleteSound() {
    setState(() {
      isRemoveRecord = true;
      audioPath = '';
    });
    log(audioPath!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Address>(
      future: futureAddress,
      builder: (context, snapshot) {
        // 1. เชื่อมต่อ/ ดึงไม่ได้
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 207, 205, 205),
            appBar: AppBar(
              toolbarHeight: 80, //ขนาดความสูง Appbar
              title: const Text(
                'เพิ่มแหล่งน้ำ',
                style: StyleAppbar,
              ),
              flexibleSpace: const BackgroundAppbar(),
              automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
              centerTitle: true, //ข้อความตรงกลาง
              backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
              elevation: 0, //ลบแรเงา
            ),
            body: Center(
                child: Column(
              children: [
                const Text(
                  "ไม่สามารถรับค่าพิกัดได้ ลองอีกครั้ง",
                  style: StyleTextError,
                ),
                Text("${snapshot.error}"),
              ],
            )),
          );
        }
        // 2. กำลังโหลดข้อมูล
        // else if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        // 3. เชื่อมต่อสำเร็จ
        // final Address detailAddress = snapshot.data!; //ดึงข้อมูลแอดเดรสที่ไปเก็บใน class Address
        return Stack(children: [
          const BackgroundAppClear(),
          Scaffold(
            appBar: AppBar(
              toolbarHeight: 80, //ขนาดความสูง Appbar
              leading: Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    timer?.cancel();
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AllConnect(userData: widget.userData)));
                  },
                ),
              ),
              title: const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "เพิ่มแหล่งน้ำ",
                  style: StyleAppbar,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0, //ลบแรเงา
            ),
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //ครึ่งบน
                  Container(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 45),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //ค่า Row ด้านซ้าย
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("สถานะ",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 34),
                                      if (isLoadingStatus) textStatus!,
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Text("ละติจูด",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 30),
                                      Text("$latitude",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Text("Altitude",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 16),
                                      Text("$cutAltitude",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Text("อำเภอ",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 35),
                                      Text("$district",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 25),
                              //ค่า Row ด้านขวา
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Accuracy",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 18),
                                      Text("$cutAccuracy",
                                          style: StyleDetailResult),
                                      const SizedBox(width: 6),
                                      const Text("m.",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Text("ลองจิจูด",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 28),
                                      Text("$longitude",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Text("จังหวัด",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 40),
                                      Text("$province",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Text("ตำบล",
                                          style: StyleDetailTitle),
                                      const SizedBox(width: 51),
                                      Text("$subdistrict",
                                          style: StyleDetailResult),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  //ครึ่งล่าง
                  Form(
                    key: formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 645,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          DropdownMenuWater(
                            onSelected: (value) {
                              setState(() {
                                selectDropdown = value;
                                selectWaterType = value;
                              });
                              log(selectWaterType!);
                            },
                            selectedValue: selectDropdown,
                            dropdownValues: dropdownList,
                            validatorText: "กรุณาระบุประเภทของแหล่งน้ำ",
                          ),
                          const SizedBox(height: 15),
                          InputMultiLine(
                            maxLines: 2,
                            labelText: "คำอธิบาย",
                            labelTextStyle: StyleLabelRegister,
                            borderSideEnable: const BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            controller: _descriptionController,
                            // validatorText: "กรุณากรอกชื่อภาษาไทยที่ถูกต้อง",
                            // pattern: r'^[ก-๏ a-z A-Z 0-9 /s]+$',
                          ),
                          const SizedBox(height: 10),
                          // แสดงรูปภาพที่เลือก
                          Expanded(
                            child: GridView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: selectedImages.length + 1,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Center(
                                          // camera_alt_rounded
                                          child: selectedImages.length == 5
                                              ? const Icon(
                                                  Icons.block_rounded,
                                                  size: 60,
                                                  color: Colors.red,
                                                )
                                              : IconButton(
                                                  icon: const Icon(Icons
                                                      .add_photo_alternate),
                                                  iconSize: 60,
                                                  color: const Color.fromARGB(
                                                      255, 4, 117, 119),
                                                  onPressed: () {
                                                    showOptionGetImage();
                                                  },
                                                ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.all(5),
                                          child: Stack(
                                            children: [
                                              Container(
                                                // height: 135,
                                                // width: 135,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                        selectedImages[
                                                            index - 1]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),

                                                //new --> XFile
                                                // child: Image.file(
                                                //   File(selectedImages[index - 1]
                                                //       .path),
                                                //   fit: BoxFit.cover,
                                                //   height: 250,
                                                //   width: 250,
                                                // ),
                                              ),
                                              Positioned(
                                                left: 98,
                                                top: -10,
                                                child: IconButton(
                                                  onPressed: () {
                                                    deleteImage(selectedImages[
                                                        index - 1]);
                                                    // deleteImage(selectedImages[index - 1].path);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                  ),
                                                  iconSize: 35,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                }),
                          ),
                          // const SizedBox(height: 40),

                          // บันทึกเสียง
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: isRecording
                                          ? Colors.red
                                          : const Color.fromARGB(
                                              255, 4, 117, 119),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: IconButton(
                                    onPressed: () {
                                      isRecording
                                          ? stopRecording()
                                          : startRecording();
                                    },
                                    icon: isRecording
                                        ? const Icon(
                                            Icons.stop_circle_outlined,
                                            size: 30,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.keyboard_voice,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              if (!isRecording &&
                                  audioPath != null &&
                                  !isRemoveRecord)
                                Row(
                                  children: [
                                    const Text(
                                      "มี 1 ไฟล์เสียง",
                                      style: StyleDetailResult,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        isPlayingRecord
                                            ? pauseRecording()
                                            : playRecording();
                                      },
                                      icon: isPlayingRecord
                                          ? const Icon(Icons.pause_circle)
                                          : const Icon(Icons.play_circle),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteSound();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ButtonSolid(
                            buttonText: "บันทึกแหล่งน้ำ",
                            textStyle: StyleFontButtonBlue,
                            fixedheight: 55,
                            fixedwidth: 325,
                            icon: Icons.send_rounded,
                            colorIcon: Colors.white,
                            color: statusText == 'ความแม่นยำสูง'
                                ? Colors.green
                                : Colors.grey,
                            // Colors.green,
                            onPressed: () async {
                              if (statusText == 'ความแม่นยำสูง') {
                                if (formKey.currentState!.validate()) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.loading,
                                    title: "กำลังบันทึกข้อมูลแหล่งน้ำ",
                                    text: "Loading...",
                                  );

                                  await uploadFile().then((res) {
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title:
                                            "สำเร็จ! โปรดรอการอนุมัติจากหน่วยงาน",
                                        confirmBtnText: "โอเค",
                                        barrierDismissible:
                                            false, //การกดบริเวณนอก Alert
                                        onConfirmBtnTap: () {
                                          formKey.currentState!.reset();
                                          timer?.cancel();
                                          // Navigator.pop(context);
                                          // Navigator.pop(context);
                                          // Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllConnect(
                                                          userData: widget
                                                              .userData)));
                                        });
                                  }).catchError((error) {
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title: error,
                                        confirmBtnText: "โอเค",
                                        barrierDismissible:
                                            false, //การกดบริเวณนอก Alert
                                        onConfirmBtnTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                  });
                                }
                              } else {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title:
                                        "ความแม่นยำต่ำเกินไป โปรดรออีกสักครู่",
                                    confirmBtnText: "โอเค",
                                    barrierDismissible:
                                        false, //การกดบริเวณนอก Alert
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                    });
                              }
                            },
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }
}
