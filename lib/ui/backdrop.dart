import 'dart:math' as math;

import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_states.dart';
import 'package:bartender/data/repository/shared_preferences_repository.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/theme/colors.dart';
import 'package:bartender/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:meta/meta.dart';

const double _kFlingVelocity = 2.0;

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
        color: getIt.get<ThemeHelper>().currentTheme == BartenderTheme.DARK
            ? frontTitleBackgroundDark
            : frontTitleBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
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
                  height: 52.0,
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
        ));
  }
}

class Backdrop extends StatefulWidget {
  final Widget frontPanel;
  final Widget backPanel;
  final Widget frontTitle;

  Backdrop({
    @required this.frontPanel,
    @required this.backPanel,
    @required this.frontTitle,
  })  : assert(frontPanel != null),
        assert(backPanel != null),
        assert(frontTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 0,
      vsync: this,
    );
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
      _controller.fling(velocity: math.max(_kFlingVelocity, -flingVelocity));
    } else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-_kFlingVelocity, -flingVelocity));
    else {
      if (_controller.value >= 0.5) {}
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
            title: InkWell(
              onTap: toggleBackdropPanelVisibility,
              child: widget.frontTitle,
            ),
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
        decoration: BoxDecoration(color: Colors.transparent),
        child: LayoutBuilder(
          builder: _buildStack,
        ));
  }
}
