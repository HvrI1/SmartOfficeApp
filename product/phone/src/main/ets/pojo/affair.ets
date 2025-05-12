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