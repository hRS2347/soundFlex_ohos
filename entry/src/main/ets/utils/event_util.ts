import emitter from '@ohos.events.emitter'
import hilog from '@ohos.hilog'
import promptAction from '@ohos.promptAction';

export enum AppEvent {
  EVENT_CHANGE_PAGE = '1',
  CHANGE_ORIENTATION = '2',
  RERUN_ROUTINE = '3',
}

export enum Direction {
  TURN_LEFT = '0',
  UP = '1',
  TURN_RIGHT = '2',
  LEFT = '3',
  DOWN = '4',
  RIGHT = '5',
  INTERACTIVE = '6',
  NO_DIRECTION = '7'
}

export class ToastHelper {
  private static instance: ToastHelper

  private constructor() {

  }

  static getInstance(): ToastHelper {
    if (!ToastHelper.instance) {
      ToastHelper.instance = new ToastHelper()
    }
    return ToastHelper.instance
  }

  toast(str, duration) {
    promptAction.showToast({
      message: str,
      duration: duration
    });
  }

  static readonly SHORT_DUR = 2000;
  static readonly MIDDLE_DUR = 1000;
  static readonly LONG_DUR = 2000;
}