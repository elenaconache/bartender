import 'dart:math' as math;

import 'package:bartender/blocs/drinks_list_cubit.dart';
import 'package:bartender/blocs/drinks_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:meta/meta.dart';

const double _kFlingVelocity = 2.0;
const Color gradientStartColor = Color(0xff004861);
const Color gradientEndColor = Color(0xff013E53);
const _frontTitleBackground = Color(0xffEBEEF1);

class _BackdropPanel extends StatelessWidget {
  _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: _frontTitleBackground,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              //  color:
              height: 52.0,
              //padding: EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.center,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline6,
                child: title,
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Builds a Backdrop.
/// A Backdrop widget has two panels, front and back. The front panel is shown
/// by default, and slides down to show the back panel, from which a user
/// can make a selection. The user can also configure the titles for when the
/// front or back panel is showing.
class Backdrop extends StatefulWidget {
  final Widget frontPanel;
  final Widget backPanel;
  final Widget frontTitle;
  final Widget backTitle;

  Backdrop({
    @required this.frontPanel,
    @required this.backPanel,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(frontPanel != null),
        assert(backPanel != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  bool _shouldDisplayCloseButton = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // This creates an [AnimationController] that can allows for animation for
    // the BackdropPanel. 0.00 means that the front panel is in "tab" (hidden)
    // mode, while 1.0 means that the front panel is open.
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 0,
      vsync: this,
    );
    //  _controller.fling(velocity: -_kFlingVelocity);
    // setState(() {
    _shouldDisplayCloseButton = false;
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void toggleBackdropPanelVisibility() {
    FocusScope.of(context).requestFocus(FocusNode());
    _controller.fling(
        velocity: _backdropPanelVisible ? -_kFlingVelocity : _kFlingVelocity);
    setState(() {
      _shouldDisplayCloseButton = _backdropPanelVisible;
    });
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) {
      return;
    }
    _controller.value -= details.primaryDelta / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0) {
      setState(() {
        _shouldDisplayCloseButton = true;
      });
      _controller.fling(velocity: math.max(_kFlingVelocity, -flingVelocity));
    } else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-_kFlingVelocity, -flingVelocity));
    else {
      if (_controller.value >= 0.5) {
        setState(() {
          _shouldDisplayCloseButton = true;
        });
      }
      _controller.fling(
          velocity:
              _controller.value < 0.5 ? -_kFlingVelocity : _kFlingVelocity);
    }
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    Animation<RelativeRect> panelAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Stack(
      children: <Widget>[
        widget.backPanel,
        PositionedTransition(
          rect: panelAnimation,
          child: _BackdropPanel(
            onTap: () => {toggleBackdropPanelVisibility},
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            title: widget.frontTitle,
            child: widget.frontPanel,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<DrinksListCubit, DrinksListState>(
      builder: (context, state) {
        return _buildWidget();
      },
      listener: (context, state) {
        if (state is DrinksListError) {
          toggleBackdropPanelVisibility();
        }
        return _buildWidget();
      },
    );
  }

  Container _buildWidget() {
    return Container(
        key: _backdropKey,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStartColor, gradientEndColor],
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: LayoutBuilder(
            builder: _buildStack,
          ),
        ));
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        iconSize: 30,
        onPressed: toggleBackdropPanelVisibility,
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      title: widget.backTitle,
      actionsIconTheme: IconThemeData(
        size: 30.0,
        color: Colors.white,
      ),
      actions: _shouldDisplayCloseButton
          ? <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _controller.fling(velocity: -_kFlingVelocity);
                      setState(() {
                        _shouldDisplayCloseButton = false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 26.0,
                    ),
                  )),
            ]
          : [],
    );
  }
}
