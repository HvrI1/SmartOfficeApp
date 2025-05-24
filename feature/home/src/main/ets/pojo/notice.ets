export interface NoticeInfo{
  title:string;
  content:string;
  imgUrl:string;
  publisherId:number;
  status?:number;
  viewCount?:number;
  createTime:string;
  updateTime:string;
  attachments:NoticeAttachment;
}
export class NoticeModel implements NoticeInfo{
  title: string;
  content: string;
  imgUrl: string;
  publisherId: number;
  status?: number | undefined;
  viewCount?: number | undefined;
  createTime: string;
  updateTime: string;
  attachments: NoticeAttachment;

  constructor(model:NoticeInfo) {
    this.title = model.title;
    this.content = model.content;
    this.imgUrl = model.imgUrl;
    this.publisherId = model.publisherId;
    this.status = model.status;
    this.viewCount = model.viewCount;
    this.createTime = model.createTime;
    this.updateTime = model.updateTime;
    this.attachments = model.attachments;
  }
}


export interface NoticeAttachment{
  fileName:string;
  fileUrl:string;
  downloadCount?:number;
  fileSize?:string;
  createTime:string;
}
export class NoticeAttachmentModel implements NoticeAttachment{
  fileName: string;
  fileUrl: string;
  downloadCount: number|undefined;
  fileSize: string|undefined;
  createTime: string;

  constructor(model:NoticeAttachment) {
    this.fileName = model.fileName;
    this.fileUrl = model.fileUrl;
    this.downloadCount = model.downloadCount;
    this.fileSize = model.fileSize;
    this.createTime = model.createTime;
  }
}
