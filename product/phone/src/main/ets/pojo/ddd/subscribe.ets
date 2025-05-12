import { CarSubscribeInfo } from "../car";
import { MeetingSubscribeInfo } from "../meeting";

export interface SubscribeDDDInfo{
  carSubscribeVoList:CarSubscribeInfo[]
  meetingSubscribeVoList:MeetingSubscribeInfo[]
}

export class SubscribeDDDModel implements SubscribeDDDInfo{
  carSubscribeVoList: CarSubscribeInfo[];
  meetingSubscribeVoList: MeetingSubscribeInfo[];

  constructor(model:SubscribeDDDInfo) {
    this.carSubscribeVoList = model.carSubscribeVoList;
    this.meetingSubscribeVoList = model.meetingSubscribeVoList;
  }
}

