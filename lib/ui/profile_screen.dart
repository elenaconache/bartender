import 'package:bartender/constants.dart';
import 'package:bartender/ui/backdrop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return _buildProfilePortraitWidget();
  }

  List<Widget> _buildCarouselItems() {
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
  Widget _buildProfilePortraitWidget() {
    return Stack(children: [_buildCarousel(), _buildTopSection()]);
  }

  Widget _buildCarousel() {
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
                items: _buildCarouselItems(),
              ),
            ],
          )),
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
        child: CachedNetworkImage(
          imageUrl: 'https://a', //todo replace with actual data
          placeholder: (context, url) => CircularProfileAvatar(
            '',
            radius: 90,
            backgroundColor: Colors.blueGrey,
            borderWidth: 1,
            initialsText: Text(
              "EC", //todo replace with actual data
              style: TextStyle(
                  fontSize: 40, color: Colors.white, fontFamily: 'Poppins'),
            ),
            borderColor: Colors.white,
            elevation: 8.0,
            showInitialTextAbovePicture: true,
          ),
          errorWidget: (context, url, error) => CircularProfileAvatar(
            '',
            radius: 90,
            backgroundColor: Colors.blueGrey,
            borderWidth: 1,
            initialsText: Text(
              "EC", //todo replace with actual data
              style: TextStyle(
                  fontSize: 40, color: Colors.white, fontFamily: 'Poppins'),
            ),
            borderColor: Colors.white,
            elevation: 8.0,
            showInitialTextAbovePicture: true,
          ),
          fit: BoxFit.fitWidth,
        ));
  }

  Widget _buildProfileInfoWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Center(
            child: Text(
              'Elena Cristea', //todo replace with actual data
              style: whiteSmallTextStyle,
            ),
          ),
        ),
        Center(
          child: Text(
            'elena96crst@gmail.com', //todo replace with actual data
            style: whiteExtraSmallTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildTopSection() {
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
              child: Center(
                  child: Wrap(children: [
                _buildAvatarWidget(),
              ]))),
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
              _buildProfileInfoWidget(),
              FloatingActionButton(
                child: Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: gradientStartColor,
                ),
                backgroundColor: Colors.white,
                onPressed: () => {},
              )
            ],
          ),
        ]));
  }
}
