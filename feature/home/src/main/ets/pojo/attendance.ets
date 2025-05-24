export interface AttendanceInfo{
  userId:number;
  attendanceDate:string;
  location:string;
  state?:string;
  attendanceSection?:string;
  createTime?:string;
}
export class AttendanceModel implements AttendanceInfo{
  userId: number;
  attendanceDate: string;
  location: string;
  state?: string| undefined;
  attendanceSection?:string;
  createTime?: string | undefined;
  constructor(model:AttendanceInfo) {
    this.userId = model.userId;
    this.attendanceDate = model.attendanceDate;
    this.location = model.location;
    this.state = model.state;
    this.attendanceSection = model.attendanceSection;
    this.createTime = model.createTime;
  }
}