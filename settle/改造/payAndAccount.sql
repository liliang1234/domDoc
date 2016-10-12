# ҵ�񶩵����޸�
alter table tbl_biz_orders add account_unit tinyint(2) comment '���㵥λ(1�ɶ�ħ������ 2������ħ������)';
alter table tbl_biz_orders add currency tinyint(2) comment '����(1������� 2����Ԫ)';
alter table tbl_biz_orders add supplier_settle_pattern tinyint(2) comment '����ģʽ (1��ƽ̨ 2���ɹ�)';
alter table tbl_biz_orders add supplier_is_billing tinyint(2) comment '��Ӧ���ܷ�Ʊ(1 ���� 2 ����)';
alter table tbl_biz_orders add supplier_name varchar(64) comment '��Ӧ������';
alter table tbl_biz_orders add supplier_credit_pay_mode tinyint(2) comment '��Ӧ��Ӷ��֧����ʽ(1���ڿ� 2����)';
alter table tbl_biz_orders add supplier_platform_pay_mode tinyint(2) comment '��Ӧ��ƽ̨֧����ʽ(1���ڿ� 2����)';
alter table tbl_biz_orders add supplier_agent_id bigint(20) comment '��Ӧ�̴���id';
alter table tbl_biz_orders add reseller_agent_id bigint(20) comment '�����̴���id';
alter table tbl_biz_orders add supplier_agent_name varchar(64) comment '��Ӧ�̴�������';
alter table tbl_biz_orders add reseller_agent_name varchar(64) comment '�����̴�������';
alter table tbl_biz_orders add channel_name varchar(64) comment '��Ӧ����������';
alter table tbl_biz_orders add mf_discount_amount double(20,4) comment 'ħ���Żݽ��';
alter table tbl_biz_orders add supplier_discount_amount double(20,4) comment '��Ӧ���Ż��ܽ��';

select * from tbl_biz_orders;



#����Ʊ��������޸�
alter table tbl_biz_ticket_order_detail add product_name varchar(64) comment '��Ʒ����';
alter table tbl_biz_ticket_order_detail add product_channel tinyint(2) comment '��ƷƵ����1����Ʊ 2������Ʊ 3�����β�Ʒ 4�����ز� 5��ס�� 6��С��ͨ 7����ϲ�Ʒ��';
alter table tbl_biz_ticket_order_detail add p_product_id bigint(20) comment '�Ӳ�Ʒ��Ӧ�ĸ���ƷID';
alter table tbl_biz_ticket_order_detail add p_product_name varchar(64) comment '����Ʒ����';
alter table tbl_biz_ticket_order_detail add product_type tinyint(2) comment '��Ʒ����(1����Ʊ��Ʒ 2����ϲ�Ʒ��3������)';
alter table tbl_biz_ticket_order_detail add ticket_num int(11) NOT NULL comment 'Ʊ������';
alter table tbl_biz_ticket_order_detail add retail_price double(20,4) NOT NULL comment '�������ۼ�';
alter table tbl_biz_ticket_order_detail add voucher_id bigint(20) comment 'ʹ�õĺ��id';
alter table tbl_biz_ticket_order_detail add voucher_price double(20,4) comment 'ʹ�ú���Ľ��';
alter table tbl_biz_ticket_order_detail add deduction_amount double(20,4) comment '�ֿ۶�µ�ʱ�Ըò�Ʒʹ����ȯ�������ȣ�';
alter table tbl_biz_ticket_order_detail add ticket_state tinyint(2) NOT NULL comment 'Ʊ��״̬��0δ��֤ 1������֤�������Ʊ��2����֤ 3������Ʊ  4��������Ʊ��';
alter table tbl_biz_ticket_order_detail add refuse_num int(11) comment '��Ʊ����';
alter table tbl_biz_ticket_order_detail add refuse_amount double(20,4) comment '��Ʊ���';

select * from tbl_biz_ticket_order_detail;


#�¼�֧������
create table pay_order(
	id varchar(20) NOT NULL COMMENT '֧������id',
  order_id varchar(20) NOT NULL COMMENT '����ҵ�񶩵�id',
  transaction_id varchar(20) NOT NULL COMMENT '����ҵ�񶩵�����id',
  order_amount double(20,4) NOT NULL comment '�����ܽ��',
  payable_amount double(20,4) NOT NULL comment 'Ӧ֧�����',
  discount_amount double(20,4) DEFAULT '0.0000' comment '�Ż��ܽ��',
  reseller_id bigint(20) NOT NULL COMMENT '������id',
  supplier_id bigint(20) NOT NULL COMMENT '��Ӧ��id',
  payer_id bigint(20) NOT NULL COMMENT '֧����id',
  create_time timestamp DEFAULT now() COMMENT '����ʱ��',
  update_time timestamp COMMENT '������ʱ��',
  pay_type tinyint(2) NOT NULL comment '�������ͣ�1����ֵ��RECHARGE��2��֧����PAY��',
  from_type smallint(6) NOT NULL comment '������Դ',
  platform_discount double(20,4) DEFAULT '0.0000' comment 'ƽ̨�۷�',
  status tinyint(2) NOT NULL comment '����״̬��1��δ֧�� 2����֧����3�����ۣ�',
  pay_time timestamp COMMENT '֧��ʱ��',
  bank_charges double(20,4) DEFAULT '0.0000' comment '����������',
  PRIMARY KEY (`id`)
);

select * from pay_order;


#�¼�֧����ˮ��
create table pay_flow(
	id varchar(20) NOT NULL COMMENT '֧����ˮid',
  payer_id bigint(20) NOT NULL COMMENT 'ʵ��֧����id',
  order_id varchar(20) NOT NULL COMMENT '����ҵ�񶩵�id',
  deal_id varchar(64) NOT NULL COMMENT '������������ˮ��',
  receipt_money tinyint(2) NOT NULL comment '�տʽ(1��֧������2��΢�� 3����� 4���˿ۡ�5����� 6�������7������8������)',
  account_button tinyint(2) comment '�˿���(����տʽ���˿ۣ�������ϸ�˿��1��������2����Ӧ��Ӧ�գ�3�����ţ�4��Ԥ��)',
  receive_type NOT NULL COMMENT '�տ����ͣ�1-��ͨ����Ҫ��ϸ�������� 2-��Ʊ�˿� 3-�����˿',
  pay_time timestamp DEFAULT now() COMMENT '֧��ʱ��',
  receive_bank varchar(64) NOT NULL COMMENT '�տ���������',
  receive_bank_account varchar(64) NOT NULL COMMENT '�տ������˺�',
  reseller_id bigint(20) COMMENT '������id',
  reseller_name varchar(64) COMMENT '����������',
  currency tinyint(2) comment '����(1������� 2����Ԫ)',
  paid_amount double(20,4) DEFAULT '0.0000' comment '֧���ֽ�Ľ��',
  discount_money double(20,4) DEFAULT '0.0000' comment '�Ż��ۿ۽��',
  discount_type tinyint(2) comment '�Ż����ͣ�1�������2����������',
  bank_charges double(20,4) DEFAULT '0.0000' comment '����������',
  PRIMARY KEY (`id`)
);
select * from pay_flow;


#�����˻��ֵ��
create table account_dict(
	id bigint(20) NOT NULL COMMENT '�˻��ֵ�id',
  pid bigint(20) DEFAULT '0' COMMENT '����������id',
  account_level tinyint(2) COMMENT '�˻��㼶',
  account_type varchar(64) NOT NULL COMMENT '�˻����ͣ�1����Ӧ�� 2�����̣�3��ħ����4��Ʊ֮�ң�5�������̣�',
  account_name varchar(64) NOT NULL COMMENT '�˻����ƣ�Ӧ�գ�Ӧ�������գ��Ѹ���Ԥ��_Ԥ��ȡ�������',
  remarks varchar(2000) COMMENT '�˻���ע',
  create_time timestamp DEFAULT now() COMMENT '����ʱ��',
  status tinyint(2) COMMENT '״̬(1������ 2��ɾ�� )',
  PRIMARY KEY (`id`)
);
select * from account_dict;


#�����˻�����
create table account_balance(
 id bigint(20) NOT NULL COMMENT '�˻����id',
 reseller_id bigint(20) COMMENT '������id',
 supplier_id bigint(20) COMMENT '��Ӧ��id',
 refer_supplier_id bigint(20) COMMENT '�ο���Ӧ��id',
 user_type tinyint(2) NOT NULL COMMENT '�˻����ͣ�1����Ӧ�� 2�����̣�3��ħ����4��Ʊ֮�ң�5�������̣�',
 account_company_name varchar(64) NOT NULL COMMENT '��ǰ�����˻���˾����',
 refer_account_type tinyint(2) NOT NULL COMMENT '���׷��˻����ͣ�1����Ӧ�� 2�����̣�3��ħ����4��Ʊ֮�ң�5�������̣�',
 trade_company_name varchar(64) NOT NULL COMMENT '���׷���˾����',
 refer_account_type COMMENT '�˻����ͣ�1����Ӧ�� 2�����̣�3��ħ����4��Ʊ֮�ң�5�������̣�',
 refer_company_name varchar(64) COMMENT '�ο����˻���˾����',
 account_dict_name varchar(64) NOT NULL COMMENT '��ǰ�����˻��ֵ�����',
 account_dict_id bigint(20) NOT NULL COMMENT '��ǰ�����˻��ֵ�id',
 period varchar(64) NOT NULL COMMENT '�ڼ�',
 begin_period double(20,4) DEFAULT '0.0000' COMMENT '�ڳ����',
 cur_period double(20,4) DEFAULT '0.0000' '���ڷ�����',
 final_period double(20,4) DEFAULT '0.0000' COMMENT '��ĩ���',
 create_time timestamp COMMENT '����ʱ��',
 update_time timestamp COMMENT '�޸�ʱ��',
 PRIMARY KEY (`id`)
);
select * from account_balance;


#�����˻���ϸ��
create table account_detail_flow(
 id bigint(20) NOT NULL COMMENT '�˻���ϸid',
 source_system tinyint(2) NOT NULL COMMENT '��Դϵͳ(1��֧�����ģ�2������ϵͳ��3��������ϵͳ��4����Ӧ��ϵͳ)',
 business_type tinyint(2) NOT NULL COMMENT 'ҵ������(1�����������֣�2����Ӧ�����֣�3���˿�-���������֣�4��������������֣�5�����Ӧ�����֣�6��������/��㣬7��Ԥ��֧����)',
 create_time timestamp DEFAULT now() COMMENT '����ʱ��',
 document_num tinyint(2) NOT NULL COMMENT '��������(1��֧����ˮ��2�����㵥��3�����˵���)',
 order_id varchar(20) NOT NULL COMMENT '����ҵ�񶩵�id',
 supplier_id bigint(20) NOT NULL COMMENT '��Ӧ��id',
 supplier_name varchar(64) COMMENT '��Ӧ������',
 supplier_account_type tinyint(2) NOT NULL COMMENT '��Ӧ�����˻�����',
 supplier_account_name varchar(64) COMMENT '��Ӧ�������˻���',
 supplier_acount_money double(20,4) DEFAULT '0.0000' COMMENT '��Ӧ���˻����',
 reseller_id bigint(20) NOT NULL COMMENT '������id',
 reseller_name varchar(64) COMMENT '����������',
 reseller_account_type tinyint(2) NOT NULL COMMENT '�������˻�����',
 reseller_account_name varchar(64) NOT NULL COMMENT '�����̲����˻���',
 reseller_acount_money double(20,4) DEFAULT '0.0000' COMMENT '�������˻����',
 remarks varchar(2000) COMMENT '�˻���ע',
 refer_account_type tinyint(2) NOT NULL COMMENT '�ο����˻�����',
 refer_user_name varchar(64) COMMENT '�ο����û���˾����',
 refer_user_id bigint(20) COMMENT '�ο����û�id',
 PRIMARY KEY (`id`)
);
select * from account_detail_flow;


#�޸Ĺ�Ӧ�̷����̱�
alter table sys_user add supplier_settle_pattern tinyint(2) comment '����ģʽ (�����ֶ� 1��ƽ̨ 2���ɹ�)';
alter table sys_user add supplier_is_billing tinyint(2) comment '��Ӧ���ܷ�Ʊ(�����ֶ� 1 ���� 2 ����)';
alter table sys_user add supplier_credit_pay_mode tinyint(2) comment '��Ӧ��Ӷ��֧����ʽ(�����ֶ� 1���ڿ� 2����)';
alter table sys_user add supplier_platform_pay_mode tinyint(2) comment '��Ӧ��ƽ̨֧����ʽ(�����ֶ�1���ڿ� 2����)';
alter table sys_user add supplier_agent_id bigint(20) comment '��Ӧ�̴���id(�����ֶ�)';
select * from sys_user;


#�������������������
create table withdraw_request(
 id bigint(20) NOT NULL COMMENT '�����������id',
 create_time timestamp DEFAULT now() COMMENT '����ʱ��',
 account_type tinyint(2) NOT NULL COMMENT '�˻����ͣ�1����Ӧ�� 2�����̣�3��ħ����4��Ʊ֮�ң�5�������̣�',
 user_id bigint(20) NOT NULL COMMENT '��Ӧ�ķ����̻��߹�Ӧ��id',
 user_name varchar(64) NOT NULL COMMENT '��Ӧ�ķ����̻��߹�Ӧ��name',
 withdraw_money double(20,4) NOT NULL COMMENT '�������ֽ��',
 state tinyint(2) NOT NULL COMMENT '�������봦���״̬��1���ɹ� 2��ʧ�� 3���ܾ���',
 pay_deal_id bigint(20) NOT NULL COMMENT '��Ӧ��֧����ˮid',
 PRIMARY KEY (`id`)
);
select * from withdraw_request;


