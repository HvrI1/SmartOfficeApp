//广告类型和实例
export interface AdvertInfo{

    advertName:string;
    advertUrl:string;
    linkUrl?:string;
    type?:number; // 1-图片 2-视频
    position?:string;
    duration:number;
    clickCount?:number;
}
export class AdvertModel implements AdvertInfo{
  advertName: string;
  advertUrl: string;
  linkUrl?: string | undefined;
  type?: number | undefined;
  position?: string | undefined;
  duration: number;
  clickCount?: number | undefined;
  constructor(model:AdvertInfo) {
    this.advertName = model.advertName;
    this.advertUrl = model.advertUrl;
    this.linkUrl = model.linkUrl;
    this.type = model.type;
    this.position = model.position;
    this.duration = model.duration;
    this.clickCount = model.clickCount;
  }
}

//
export interface getAdvertDto{
  position:string,
  advertNum:number
}