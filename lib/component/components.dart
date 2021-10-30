library components;

import 'dart:async' as async;
import 'dart:developer';

import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_view.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:forge2d/src/dynamics/body.dart';

part 'background_component.dart';
part 'components_priority.dart';
part 'fixture_component.dart';
part 'youngster_component.dart';
