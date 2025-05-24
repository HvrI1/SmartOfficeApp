import { AffairInfo,MeetingRoomInfo, MeetingSubscribeInfo, CarSubscribeInfo,
  User } from "../../pojo";

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



export interface  SubscribeMeetingDDDInfo{
  meetingRoom:MeetingRoomInfo,
  user:User,
  affair:AffairInfo,
  meetingSubscribe:MeetingSubscribeInfo
}

export class SubscribeMeetingDDDModel implements SubscribeMeetingDDDInfo{
  meetingRoom: MeetingRoomInfo;
  user: User;
  affair: AffairInfo;
  meetingSubscribe: MeetingSubscribeInfo;

  constructor(model:SubscribeMeetingDDDInfo) {
    this.meetingRoom = model.meetingRoom;
    this.user = model.user;
    this.affair = model.affair;
    this.meetingSubscribe = model.meetingSubscribe;
  }


}

