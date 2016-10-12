# 业务订单表修改
alter table tbl_biz_orders add account_unit tinyint(2) comment '核算单位(1成都魔方旅游 2、北京魔方旅游)';
alter table tbl_biz_orders add currency tinyint(2) comment '币种(1、人民币 2、美元)';
alter table tbl_biz_orders add supplier_settle_pattern tinyint(2) comment '结算模式 (1、平台 2、采购)';
alter table tbl_biz_orders add supplier_is_billing tinyint(2) comment '供应商能否开票(1 可以 2 不可)';
alter table tbl_biz_orders add supplier_name varchar(64) comment '供应商名称';
alter table tbl_biz_orders add supplier_credit_pay_mode tinyint(2) comment '供应商佣金支付方式(1、内扣 2、后付)';
alter table tbl_biz_orders add supplier_platform_pay_mode tinyint(2) comment '供应商平台支付方式(1、内扣 2、后付)';
alter table tbl_biz_orders add supplier_agent_id bigint(20) comment '供应商代理id';
alter table tbl_biz_orders add reseller_agent_id bigint(20) comment '分销商代理id';
alter table tbl_biz_orders add supplier_agent_name varchar(64) comment '供应商代理名称';
alter table tbl_biz_orders add reseller_agent_name varchar(64) comment '分销商代理名称';
alter table tbl_biz_orders add channel_name varchar(64) comment '供应商渠道名称';
alter table tbl_biz_orders add mf_discount_amount double(20,4) comment '魔方优惠金额';
alter table tbl_biz_orders add supplier_discount_amount double(20,4) comment '供应商优惠总金额';

select * from tbl_biz_orders;



#订单票的详情表修改
alter table tbl_biz_ticket_order_detail add product_name varchar(64) comment '产品名称';
alter table tbl_biz_ticket_order_detail add product_channel tinyint(2) comment '产品频道（1、门票 2、演艺票 3、旅游产品 4、土特产 5、住宿 6、小交通 7、组合产品）';
alter table tbl_biz_ticket_order_detail add p_product_id bigint(20) comment '子产品对应的父产品ID';
alter table tbl_biz_ticket_order_detail add p_product_name varchar(64) comment '父产品名称';
alter table tbl_biz_ticket_order_detail add product_type tinyint(2) comment '产品类型(1、联票产品 2、组合产品，3、其他)';
alter table tbl_biz_ticket_order_detail add ticket_num int(11) NOT NULL comment '票的数量';
alter table tbl_biz_ticket_order_detail add retail_price double(20,4) NOT NULL comment '建议零售价';
alter table tbl_biz_ticket_order_detail add voucher_id bigint(20) comment '使用的红包id';
alter table tbl_biz_ticket_order_detail add voucher_price double(20,4) comment '使用红包的金额';
alter table tbl_biz_ticket_order_detail add deduction_amount double(20,4) comment '抵扣额（下单时对该产品使用了券，立减等）';
alter table tbl_biz_ticket_order_detail add ticket_state tinyint(2) NOT NULL comment '票的状态（0未验证 1部分验证（针对联票）2已验证 3、已退票  4、申请退票）';
alter table tbl_biz_ticket_order_detail add refuse_num int(11) comment '退票数量';
alter table tbl_biz_ticket_order_detail add refuse_amount double(20,4) comment '退票金额';

select * from tbl_biz_ticket_order_detail;


#新加支付订单
create table pay_order(
	id varchar(20) NOT NULL COMMENT '支付订单id',
  order_id varchar(20) NOT NULL COMMENT '关联业务订单id',
  transaction_id varchar(20) NOT NULL COMMENT '关联业务订单交易id',
  order_amount double(20,4) NOT NULL comment '订单总金额',
  payable_amount double(20,4) NOT NULL comment '应支付金额',
  discount_amount double(20,4) DEFAULT '0.0000' comment '优惠总金额',
  reseller_id bigint(20) NOT NULL COMMENT '分销商id',
  supplier_id bigint(20) NOT NULL COMMENT '供应商id',
  payer_id bigint(20) NOT NULL COMMENT '支付者id',
  create_time timestamp DEFAULT now() COMMENT '创建时间',
  update_time timestamp COMMENT '最后操作时间',
  pay_type tinyint(2) NOT NULL comment '单订类型：1、充值（RECHARGE）2、支付（PAY）',
  from_type smallint(6) NOT NULL comment '订单来源',
  platform_discount double(20,4) DEFAULT '0.0000' comment '平台扣费',
  status tinyint(2) NOT NULL comment '订单状态（1、未支付 2、已支付、3已评价）',
  pay_time timestamp COMMENT '支付时间',
  bank_charges double(20,4) DEFAULT '0.0000' comment '银行手续费',
  PRIMARY KEY (`id`)
);

select * from pay_order;


#新加支付流水表
create table pay_flow(
	id varchar(20) NOT NULL COMMENT '支付流水id',
  payer_id bigint(20) NOT NULL COMMENT '实际支付者id',
  order_id varchar(20) NOT NULL COMMENT '关联业务订单id',
  deal_id varchar(64) NOT NULL COMMENT '第三方交易流水号',
  receipt_money tinyint(2) NOT NULL comment '收款方式(1、支付宝、2、微信 3、异度 4、账扣、5、电汇 6、红包，7、劵，8、积分)',
  account_button tinyint(2) comment '账扣项(如果收款方式是账扣，给出明细账扣项：1、其它，2、供应商应收，3、授信，4、预存)',
  receive_type NOT NULL COMMENT '收款类型（1-普通：需要明细至订单号 2-退票退款 3-提现退款）',
  pay_time timestamp DEFAULT now() COMMENT '支付时间',
  receive_bank varchar(64) NOT NULL COMMENT '收款银行名称',
  receive_bank_account varchar(64) NOT NULL COMMENT '收款银行账号',
  reseller_id bigint(20) COMMENT '分销商id',
  reseller_name varchar(64) COMMENT '分销商名称',
  currency tinyint(2) comment '币种(1、人民币 2、美元)',
  paid_amount double(20,4) DEFAULT '0.0000' comment '支付现金的金额',
  discount_money double(20,4) DEFAULT '0.0000' comment '优惠折扣金额',
  discount_type tinyint(2) comment '优惠类型（1、红包，2、劵。。）',
  bank_charges double(20,4) DEFAULT '0.0000' comment '银行手续费',
  PRIMARY KEY (`id`)
);
select * from pay_flow;


#新增账户字典表
create table account_dict(
	id bigint(20) NOT NULL COMMENT '账户字典id',
  pid bigint(20) DEFAULT '0' COMMENT '关联父级别id',
  account_level tinyint(2) COMMENT '账户层级',
  account_type varchar(64) NOT NULL COMMENT '账户类型（1、供应商 2分销商，3、魔方，4、票之家，5、代理商）',
  account_name varchar(64) NOT NULL COMMENT '账户名称（应收，应付，已收，已付，预收_预存等。。。）',
  remarks varchar(2000) COMMENT '账户备注',
  create_time timestamp DEFAULT now() COMMENT '创建时间',
  status tinyint(2) COMMENT '状态(1、可用 2、删除 )',
  PRIMARY KEY (`id`)
);
select * from account_dict;


#新增账户余额表
create table account_balance(
 id bigint(20) NOT NULL COMMENT '账户余额id',
 reseller_id bigint(20) COMMENT '分销商id',
 supplier_id bigint(20) COMMENT '供应商id',
 refer_supplier_id bigint(20) COMMENT '参考供应商id',
 user_type tinyint(2) NOT NULL COMMENT '账户类型（1、供应商 2分销商，3、魔方，4、票之家，5、代理商）',
 account_company_name varchar(64) NOT NULL COMMENT '当前交易账户公司名称',
 refer_account_type tinyint(2) NOT NULL COMMENT '交易方账户类型（1、供应商 2分销商，3、魔方，4、票之家，5、代理商）',
 trade_company_name varchar(64) NOT NULL COMMENT '交易方公司名称',
 refer_account_type COMMENT '账户类型（1、供应商 2分销商，3、魔方，4、票之家，5、代理商）',
 refer_company_name varchar(64) COMMENT '参考的账户公司名称',
 account_dict_name varchar(64) NOT NULL COMMENT '当前交易账户字典名称',
 account_dict_id bigint(20) NOT NULL COMMENT '当前交易账户字典id',
 period varchar(64) NOT NULL COMMENT '期间',
 begin_period double(20,4) DEFAULT '0.0000' COMMENT '期初余额',
 cur_period double(20,4) DEFAULT '0.0000' '本期发生额',
 final_period double(20,4) DEFAULT '0.0000' COMMENT '期末余额',
 create_time timestamp COMMENT '创建时间',
 update_time timestamp COMMENT '修改时间',
 PRIMARY KEY (`id`)
);
select * from account_balance;


#新增账户明细表
create table account_detail_flow(
 id bigint(20) NOT NULL COMMENT '账户明细id',
 source_system tinyint(2) NOT NULL COMMENT '来源系统(1、支付中心，2、结算系统，3、分销商系统，4、供应商系统)',
 business_type tinyint(2) NOT NULL COMMENT '业务类型(1、分销商提现，2、供应商提现，3、退款-分销商提现，4、付款分销商提现，5、付款供应商提现，6、第三方/电汇，7、预存支付等)',
 create_time timestamp DEFAULT now() COMMENT '创建时间',
 document_num tinyint(2) NOT NULL COMMENT '单据类型(1、支付流水，2、结算单，3、对账单号)',
 order_id varchar(20) NOT NULL COMMENT '关联业务订单id',
 supplier_id bigint(20) NOT NULL COMMENT '供应商id',
 supplier_name varchar(64) COMMENT '供应方名称',
 supplier_account_type tinyint(2) NOT NULL COMMENT '供应方的账户类型',
 supplier_account_name varchar(64) COMMENT '供应方财务账户名',
 supplier_acount_money double(20,4) DEFAULT '0.0000' COMMENT '供应方账户金额',
 reseller_id bigint(20) NOT NULL COMMENT '分销商id',
 reseller_name varchar(64) COMMENT '分销商名称',
 reseller_account_type tinyint(2) NOT NULL COMMENT '分销商账户类型',
 reseller_account_name varchar(64) NOT NULL COMMENT '分销商财务账户名',
 reseller_acount_money double(20,4) DEFAULT '0.0000' COMMENT '分销商账户金额',
 remarks varchar(2000) COMMENT '账户备注',
 refer_account_type tinyint(2) NOT NULL COMMENT '参考的账户类型',
 refer_user_name varchar(64) COMMENT '参考的用户公司名称',
 refer_user_id bigint(20) COMMENT '参考的用户id',
 PRIMARY KEY (`id`)
);
select * from account_detail_flow;


#修改供应商分销商表
alter table sys_user add supplier_settle_pattern tinyint(2) comment '结算模式 (新增字段 1、平台 2、采购)';
alter table sys_user add supplier_is_billing tinyint(2) comment '供应商能否开票(新增字段 1 可以 2 不可)';
alter table sys_user add supplier_credit_pay_mode tinyint(2) comment '供应商佣金支付方式(新增字段 1、内扣 2、后付)';
alter table sys_user add supplier_platform_pay_mode tinyint(2) comment '供应商平台支付方式(新增字段1、内扣 2、后付)';
alter table sys_user add supplier_agent_id bigint(20) comment '供应商代理id(新增字段)';
select * from sys_user;


#新增待处理的提现请求
create table withdraw_request(
 id bigint(20) NOT NULL COMMENT '待处理的提现id',
 create_time timestamp DEFAULT now() COMMENT '创建时间',
 account_type tinyint(2) NOT NULL COMMENT '账户类型（1、供应商 2分销商，3、魔方，4、票之家，5、代理商）',
 user_id bigint(20) NOT NULL COMMENT '对应的分销商或者供应商id',
 user_name varchar(64) NOT NULL COMMENT '对应的分销商或者供应商name',
 withdraw_money double(20,4) NOT NULL COMMENT '申请提现金额',
 state tinyint(2) NOT NULL COMMENT '提现申请处理的状态（1、成功 2、失败 3、拒绝）',
 pay_deal_id bigint(20) NOT NULL COMMENT '对应的支付流水id',
 PRIMARY KEY (`id`)
);
select * from withdraw_request;


