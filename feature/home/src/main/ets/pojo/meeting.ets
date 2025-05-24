export interface MeetingSubscribeInfo{
  id:number;
  startTime:string;
  endTime:string;
  status:string;
  roomId:number;
  affairId:number;
  meetingTheme:string;
  participants:number;
  department:string;
  meetingType?:string;
  createTime:string;
}
export class MeetingSubscribeModel implements MeetingSubscribeInfo{
  id:number;
  startTime: string;
  endTime: string;
  status:string;
  roomId:number;
  affairId:number;
  meetingTheme: string;
  participants: number;
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
    this.roomId = model.roomId;
    this.affairId = model.affairId;
    this.id = model.id;
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