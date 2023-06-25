// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/shared/cubit/app/app_states.dart';
import 'package:smartmate/shared/styles/colors.dart';
import '../../shared/cubit/app/app_cubit.dart';

class AddStory extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is CreateStorySuccesState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            foregroundColor: defaultColor,
            elevation: 0,
            title: Text("Add a new story"),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  onPressed: () {
                    var now = DateTime.now();
                    if (AppCubit.get(context).storyImage == null) {
                      AppCubit.get(context).createStory(
                          dateTime: now.toString(), text: textController.text);
                    } else {
                      AppCubit.get(context).uploadStoryImage(
                          dateTime: now.toString(), text: textController.text);
                    }
                  },
                  icon: Icon(
                    Icons.done,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              if (state is CreateStoryLoadingState)
                LinearProgressIndicator(
                  color: defaultColor,
                ),
              if (state is CreateStoryLoadingState)
                SizedBox(
                  height: 10,
                ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(AppCubit.get(context).userModel.image!),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      AppCubit.get(context).userModel.name!,
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      hintText: "Caption ...", border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (AppCubit.get(context).storyImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 340,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(
                              AppCubit.get(context).storyImage!,
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                    IconButton(
                        onPressed: () {
                          AppCubit.get(context).removeStoryImage();
                        },
                        icon: CircleAvatar(
                            backgroundColor: defaultColor,
                            radius: 20,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ))),
                  ],
                ),
              SizedBox(
                height: 60,
              ),
              if (AppCubit.get(context).storyImage == null)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "     Choose an Option",
                              ),
                              content: Container(
                                width: 70,
                                height: 70,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        AppCubit.get(context)
                                            .getStoryImagefromGallery(context);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: defaultColor,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Gallery",
                                            style:
                                                TextStyle(color: defaultColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "or",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.grey[600]),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        AppCubit.get(context)
                                            .getStoryImagefromCamera(context);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.camera,
                                            color: defaultColor,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Camera",
                                            style:
                                                TextStyle(color: defaultColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: defaultColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Add Photo",
                              style: TextStyle(color: defaultColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ]),
          ),
        );
      },
    );
  }
}
