export interface AffairInfo{
  id:number;
  user:string;
  type:string;
  status:string;
  applyReason?:string;
  createTime:string;
  updateTime:string;
}
export class AffairModel implements AffairInfo{
  id: number;
  user: string;
  type: string;
  status: string;
  applyReason?: string | undefined;
  createTime: string;
  updateTime: string;

  constructor(model:AffairInfo) {
    this.id = model.id;
    this.user = model.user;
    this.type = model.type;
    this.status = model.status;
    this.applyReason = model.applyReason;
    this.createTime = model.createTime;
    this.updateTime = model.updateTime;
  }


}

export interface ApprovalNumInfo{
  //状态：当前事务总数
  currentAllAffairNum:number
  //状态：当前待办的数量
  currentWaitingNum:number
  //状态：当前已审核的数量
  currentFinishNum:number
  //状态：当前已拒绝的数量
  currentRejectNum:number
}



export  class ApprovalNumModel implements ApprovalNumInfo{
  //状态：当前事务总数
  currentAllAffairNum:number
  //状态：当前待办的数量
  currentWaitingNum:number
  //状态：当前已审核的数量
  currentFinishNum:number
  //状态：当前已拒绝的数量
  currentRejectNum:number

  constructor(model:ApprovalNumInfo) {
    this.currentAllAffairNum = model.currentAllAffairNum;
    this.currentWaitingNum = model.currentWaitingNum;
    this.currentFinishNum = model.currentFinishNum;
    this.currentRejectNum = model.currentRejectNum;
  }


}

export interface  ApprovalDto{
  meetingSubscribeId:number;
  affairId:number;
  status:number
}
