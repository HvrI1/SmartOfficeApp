export interface MeetingSubscribeInfo{
  startTime:string;
  endTime:string;
  meetingTheme:string;
  participants:string;
  department:string;
  meetingType?:string;
  createTime:string;
}
export class MeetingSubscribeModel implements MeetingSubscribeInfo{
  startTime: string;
  endTime: string;
  meetingTheme: string;
  participants: string;
  department: string;
  meetingType: string | undefined;
  createTime: string;

  constructor(model:MeetingSubscribeInfo) {
    this.startTime = model.startTime;
    this.endTime = model.endTime;
    this.meetingTheme = model.meetingTheme;
    this.participants = model.participants;
    this.department = model.department;
    this.meetingType = model.meetingType;
    this.createTime = model.createTime;
  }



}

export interface MeetingRoomInfo{
  building:string;
  roomNumber:string;
  capacity:number;
  equipment?:string;
  status?:string;
  coverUrl?:string;
}
export class MeetingRoomModel implements MeetingRoomInfo{
  building: string;
  roomNumber: string;
  capacity: number;
  equipment?: string | undefined;
  status?: string | undefined;
  coverUrl?: string | undefined;

  constructor(model:MeetingRoomInfo) {
    this.building = model.building;
    this.roomNumber = model.roomNumber;
    this.capacity = model.capacity;
    this.equipment = model.equipment;
    this.status = model.status;
    this.coverUrl = model.coverUrl;
  }

}