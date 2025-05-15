export interface MeetingSubscribeInfo{
  startTime:string;
  endTime:string;
  status:string;
  meetingTheme:string;
  participants:string;
  department:string;
  meetingType?:string;
  createTime:string;
}
export class MeetingSubscribeModel implements MeetingSubscribeInfo{
  startTime: string;
  endTime: string;
  status:string;
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
    this.status = model.status;
  }



}

export interface MeetingRoomInfo{
  id:number
  building:string;
  roomNumber:string;
  capacity:number;
  status?:string;
  coverUrl?:string;
}
export class MeetingRoomModel implements MeetingRoomInfo{
  id:number
  building: string;
  roomNumber: string;
  capacity: number;
  status?: string | undefined;
  coverUrl?: string | undefined;

  constructor(model:MeetingRoomInfo) {
    this.id = model.id
    this.building = model.building;
    this.roomNumber = model.roomNumber;
    this.capacity = model.capacity;
    this.status = model.status;
    this.coverUrl = model.coverUrl;
  }

}