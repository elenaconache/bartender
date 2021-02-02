import 'dart:io';

import 'package:bartender/blocs/profile/profile_cubit.dart';
import 'package:bartender/blocs/profile/profile_states.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/ui/backdrop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final List<String> testImgList = [
  'https://cdn.pixabay.com/photo/2020/06/17/18/03/lights-5310589__340.jpg',
  'https://cdn.pixabay.com/photo/2020/10/07/15/20/man-5635507__340.jpg',
  'https://cdn.pixabay.com/photo/2020/09/09/14/47/man-5557864__340.jpg',
  'https://cdn.pixabay.com/photo/2020/09/13/04/13/coffee-5567269__340.jpg'
]; //todo remove once real data is setup

class ProfileScreen extends StatefulWidget {
  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  String _firebaseImage;
  User _account;

  @override
  Widget build(BuildContext context) {
    if (_account == null) {
      final cubit = context.cubit<ProfileCubit>();
      cubit.getInitialData();
    }

    return CubitConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return _buildWidget(state, context);
      },
      listener: (context, state) {
        return _buildWidget(state, context);
      },
    );
  }

  Widget _buildWidget(ProfileState state, BuildContext context) {
    print("state is $state");
    if (state is ProfileSuccess || state is ProfileIncomplete) {
      if (state is ProfileSuccess) {
        _firebaseImage = state.firebaseImageUrl;
        _account = state.account;
      } else if (state is ProfileIncomplete) {
        _account = state.account;
      }
      if (_image != null) {
        _uploadImageToFirebase(context);
      }
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return _buildProfilePortraitWidget(context);
      } else {
        return _buildProfileLandscapeWidget(context);
      }
    } else if (state is ProfileError) {
      return Container(); //todo handle it with a widget
    } else if (state is ProfileLoading || state is ProfileInitial) {
      return _buildLoadingWidget();
    } else if (state is ProfileEmpty) {
      return Container(); //todo handle it with a widget
    } else {
      return Container(); //todo handle it with a widget
    }
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> _buildCarouselItems(BuildContext context) {
    return testImgList
        .map(
          (item) => Container(
              child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: CachedNetworkImage(
                imageUrl: item,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.8),
          )),
        )
        .toList();
  }

  //todo login redesign [Pinterest]
  //todo landscape widget
  Widget _buildProfilePortraitWidget(BuildContext context) {
    return Stack(
        children: [_buildCarousel(context), _buildTopSection(context)]);
  }

  Widget _buildCarousel(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 24),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Recent activity',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: gradientStartColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )),
              CarouselSlider(
                options: CarouselOptions(
                  height: 240,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                ),
                items: _buildCarouselItems(context),
              ),
            ],
          )),
    );
  }

  Widget _buildLandscapeCarousel(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
            height: 260,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 500),
            scrollDirection: Axis.vertical),
        items: _buildCarouselItems(context),
      ),
    );
  }

  Widget _buildAvatarWidget() {
    return CircularProfileAvatar('',
        radius: 90,
        backgroundColor: Colors.blueGrey,
        borderWidth: 1,
        borderColor: Colors.white,
        elevation: 5.0,
        cacheImage: true,
        child: _image != null
            ? Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(_image.path)), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(90),
                ),
              )
            : (_firebaseImage != null
                ? _buildAvatarWidgetFromFirebase()
                : _buildInitialsAvatar()));
  }

  Widget _buildInitialsAvatar() {
    return CircularProfileAvatar(
      '',
      radius: 90,
      backgroundColor: Colors.blueGrey,
      borderWidth: 1,
      initialsText: Text(
        _account != null
            ? _account.displayName
                .split(" ")
                .map((e) => e.isNotEmpty ? e[0] : "")
                .join()
            : "",
        style:
            TextStyle(fontSize: 40, color: Colors.white, fontFamily: 'Poppins'),
      ),
      borderColor: Colors.white,
      elevation: 8.0,
      showInitialTextAbovePicture: true,
    );
  }

  Widget _buildAvatarWidgetLandscape() {
    print("building avatar with ${_image.path}");
    return CircularProfileAvatar('',
        radius: 90,
        backgroundColor: Colors.blueGrey,
        borderWidth: 1,
        borderColor: gradientStartColor,
        elevation: 5.0,
        cacheImage: true,
        child: _image != null
            ? Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(_image.path)), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(90),
                ),
              )
            : _buildInitialsAvatar());
  }

  Widget _buildProfileInfoWidget(Orientation orientation) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Center(
            child: Text(
              _account != null ? _account.displayName : "",
              style: orientation == Orientation.portrait
                  ? whiteSmallTextStyle
                  : gradientColorTextStyle,
            ),
          ),
        ),
        Center(
          child: Text(
            _account != null ? _account.email : "",
            style: orientation == Orientation.portrait
                ? whiteSmallTextStyle
                : gradientColorTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: gradientStartColor),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(child: Wrap(children: [_buildAvatarWidget()]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                child: Icon(
                  Icons.nights_stay,
                  size: 24,
                  color: gradientStartColor,
                ),
                backgroundColor: Colors.white,
                onPressed: () => {},
              ),
              _buildProfileInfoWidget(Orientation.portrait),
              FloatingActionButton(
                child: Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: gradientStartColor,
                ),
                backgroundColor: Colors.white,
                onPressed: () => {_showPicker(context)},
              )
            ],
          ),
        ]));
  }

  Widget _buildTopSectionLandscape(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: 24,
        ),
        height: MediaQuery.of(context).size.height * 0.4,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                  child: Wrap(children: [
                _buildAvatarWidgetLandscape(),
              ]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                child: Icon(
                  Icons.nights_stay,
                  size: 24,
                  color: Colors.white,
                ),
                backgroundColor: gradientStartColor,
                onPressed: () => {},
              ),
              _buildProfileInfoWidget(Orientation.landscape),
              FloatingActionButton(
                child: Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: Colors.white,
                ),
                backgroundColor: gradientStartColor,
                onPressed: () => {_showPicker(context)},
              )
            ],
          ),
        ]));
  }

  Widget _buildProfileLandscapeWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildTopSectionLandscape(context),
            flex: 1,
          ),
          Expanded(
            flex: 1,
            child: _buildLandscapeCarousel(context),
          ),
        ],
      ),
    );
  }

  void _requestImageFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image.path);
    });
  }

  void _requestImageFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _requestImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _requestImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _uploadImageToFirebase(BuildContext context) async {
    String fileName = _account.uid;
    var  firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('$profileAvatarDirectory/$fileName');
    /*var  uploadTask =*/ await firebaseStorageRef.putFile(_image);
   // var taskSnapshot = await uploadTask.onComplete;
   // taskSnapshot.ref.getDownloadURL().then(
        //  (value) => print("Done: $value"),
     //   );

  }

  Widget _buildAvatarWidgetFromFirebase() {
    return CachedNetworkImage(
      imageUrl: _firebaseImage,
      placeholder: (context, url) => _buildInitialsAvatar(),
      errorWidget: (context, url, error) => _buildInitialsAvatar(),
      fit: BoxFit.cover,
    );
  }
}
