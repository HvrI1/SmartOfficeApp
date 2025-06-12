import { ColumnInfo, ColumnType, CommonConstants, DBUtil } from 'base';
import Logger from 'base/src/main/ets/util/Logger';
import { AffairInfo } from '../pojo';
import { relationalStore } from '@kit.ArkData';

export  class ApprovalModel{

  private  APPROVAL_COLUMNS: ColumnInfo[] = [
  {
    name: 'id',
    columnName: 'id',
    type: ColumnType.LONG  // 数字类型
  },
  {
    name: 'user',
    columnName: 'user',
    type: ColumnType.STRING  // 字符串类型
  },
  {
    name: 'type',
    columnName: 'type',
    type: ColumnType.STRING
  },
  {
    name: 'status',
    columnName: 'status',
    type: ColumnType.STRING
  },
  {
    name: 'applyReason',
    columnName: 'applyReason',
    type: ColumnType.STRING  // 可选字段
  },
  {
    name: 'createTime',
    columnName: 'createTime',
    type: ColumnType.STRING
  },
  {
    name: 'updateTime',
    columnName: 'updateTime',
    type: ColumnType.STRING
  }
];


  //建表
  async createApprovalTablet(){
    //拿到数据库操作对象
    const db = DBUtil.getInstance();
    if(!db){
      Logger.error(CommonConstants.RDB_PREFIX,`createApprovalTablet()方法的db对象创建失败`)
      return
    }
    //建表
    try {
      await db.createTable(`CREATE TABLE IF NOT EXISTS approval (
    id          INTEGER       PRIMARY KEY AUTOINCREMENT,
    user        TEXT          NOT NULL,
    type        TEXT          NOT NULL,
    status      TEXT          NOT NULL,
    applyReason TEXT,
    createTime  TEXT          NOT NULL DEFAULT (datetime('now', 'localtime')),
    updateTime  TEXT          NOT NULL DEFAULT (datetime('now', 'localtime'))
    );`)
    }catch (e){
      Logger.error(CommonConstants.RDB_PREFIX,`approval表创建失败`)
    }
  }

  //检查表是否存在
  async checkTabletIsExists(tabletName:string):Promise<boolean>{
    //拿到数据库操作对象
    const db = DBUtil.getInstance();
    if(!db){
      Logger.error(CommonConstants.RDB_PREFIX,`checkTabletIsExists()方法的db对象创建失败`)
      return false
    }
    //检查
    try {
      return await db.isTableExist(tabletName)
    }catch (e) {
      Logger.error(CommonConstants.RDB_PREFIX,`checkTabletIsExists()方法的检查操作失败`)
      return false
    }
  }



  //插入待办列表数据
  async insertApprovalListData(affairInfo:AffairInfo[]){
    //从AppStorage中拿数据库操作对象
    const db = DBUtil.getInstance();
    if(!db){
      Logger.error(CommonConstants.RDB_PREFIX,`insertApprovalListData()方法的db对象创建失败`)
      return
    }
    //执行插入数据的操作
    try {
      for (const item of affairInfo) {
        await db.insert(
          "approval",       // 表名
          item,       // 插入数据对象
          this.APPROVAL_COLUMNS  // 列定义信息
        );
      }
    } catch (error) {
      Logger.error(CommonConstants.RDB_PREFIX, "insertApprovalListData()方法插入失败", JSON.stringify(error));
    }
  }


  // 查询待办列表数据
  async selectApprovalListData() {
    // 从AppStorage中拿数据库操作对象
    const db = DBUtil.getInstance();
    if (!db || !db.rdbStore) {
      Logger.error(CommonConstants.RDB_PREFIX, `selectApprovalListData()方法的db对象创建失败`);
      return
    }

    try {
      // 创建查询谓词（无条件的全表查询）
      const predicates:relationalStore.RdbPredicates = new relationalStore.RdbPredicates("approval")
      // 执行查询
      return await db.queryForList<AffairInfo>(predicates, this.APPROVAL_COLUMNS);
    } catch (error) {
      Logger.error(CommonConstants.RDB_PREFIX, "selectApprovalListData()方法查询失败", JSON.stringify(error));
      return [];
    }
  }


  //删除表
  async deleteTablet(tabletName:string){
    // 从AppStorage中拿数据库操作对象
    const db = DBUtil.getInstance();
    if (!db || !db.rdbStore) {
      Logger.error(CommonConstants.RDB_PREFIX, `deleteTablet()方法的db对象创建失败`);
      return
    }
    try {
      await db.deleteTablet("approval")
    } catch (error) {
      Logger.warn(CommonConstants.RDB_PREFIX, `deleteTablet()删除【${tabletName}】表失败`, JSON.stringify(error));
      return
    }
  }


}