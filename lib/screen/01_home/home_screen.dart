import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:warning/core/model/image_warning_response_model.dart';
import 'package:warning/core/model/word_check_response_model.dart';
import 'package:warning/core/service/service.dart';
import 'package:warning/utils/utils.dart';
import 'package:warning/widget/common/free_space.dart';
import 'package:warning/widget/common/loading_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilePickerResult? filePickerResult;

  ImageWarningResponseModel? imageWarningResponseModel;

  WordWarningResponseModel? wordWarningResponseModel;

  bool isWordLoading = false;
  bool isImageLoading = false;

  TextEditingController wordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage() async {
    setState(() {
      isImageLoading = true;
    });
    filePickerResult = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (filePickerResult != null) {
      var file = filePickerResult!.files[0].path;
      imageWarningResponseModel = await WarningService.checkImageWarning(file!);
    }
    if (imageWarningResponseModel != null) {
      showBottomSheetImageData(imageWarningResponseModel!);
    }
    setState(() {
      isImageLoading = false;
    });
  }

  showBottomSheetImageData(
          ImageWarningResponseModel imageWarningResponseModel) =>
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => Container(
          height: Utils.screenSize(context).height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const VerticalSpace(height: 30),
              Text(
                imageWarningResponseModel.unsafe
                    ? 'There is some nudity content on this image'
                    : 'There is no nudity content on this image',
              ),
              const VerticalSpace(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: imageWarningResponseModel.objects.length,
                  itemBuilder: (context, index) => Container(
                    child: Text(imageWarningResponseModel.objects[index].label),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  showBottomSheetSentanceData(
          WordWarningResponseModel wordWarningResponseModel) =>
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => Container(
          height: Utils.screenSize(context).width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const VerticalSpace(height: 20),
              Text(
                wordWarningResponseModel.clean,
              ),
            ],
          ),
        ),
      );

  Future<void> checkWords() async {
    if (wordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please enter something');
    } else {
      setState(() {
        isWordLoading = true;
      });
      wordWarningResponseModel =
          await WarningService.wordCheck(wordController.text);
      if (wordWarningResponseModel != null) {
        showBottomSheetSentanceData(wordWarningResponseModel!);
      }
      setState(() {
        isWordLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VerticalSpace(height: Utils.screenSize(context).width * 0.4),
          TextField(
            controller: wordController,
          ),
          ElevatedButton(
            onPressed: () {
              checkWords();
            },
            child: isWordLoading
                ? const LoadingOverlay()
                : const Text('check word'),
          ),
          ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: isImageLoading
                ? const LoadingOverlay()
                : const Text('check image'),
          )
        ],
      ),
    );
  }
}
