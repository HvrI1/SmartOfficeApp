export interface CarSubscribeInfo {
  startTime:string;
  endTime:string;
  departure:string;
  destination:string;
  passengers:string;
  createTime:string;
}
export class CarSubscribeModel implements CarSubscribeInfo{
  startTime: string;
  endTime: string;
  departure: string;
  destination: string;
  passengers: string;
  createTime: string;

  constructor(model:CarSubscribeInfo) {
    this.startTime = model.startTime;
    this.endTime = model.endTime;
    this.departure = model.departure;
    this.destination = model.destination;
    this.passengers = model.passengers;
    this.createTime = model.createTime;
  }
}

export interface CarInfo{
  plateNumber:string;
  brand:string;
  seats:string;
  oilType?:string;
  status?:string;
  coverUrl?:string;
  annualCheck?:string;
}
export class CarModel implements CarInfo{
  plateNumber: string;
  brand: string;
  seats: string;
  oilType: string| undefined;
  status: string| undefined;
  coverUrl: string| undefined;
  annualCheck: string | undefined;

  constructor(model:CarInfo) {
    this.plateNumber = model.plateNumber;
    this.brand = model.brand;
    this.seats = model.seats;
    this.oilType = model.oilType;
    this.status = model.status;
    this.coverUrl = model.coverUrl;
    this.annualCheck = model.annualCheck;
  }


}