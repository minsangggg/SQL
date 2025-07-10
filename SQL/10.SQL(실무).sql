use 분석실습;

###1. 매출 트렌드

# 1-1.기간별 매출 현황이 어떤 트렌드를 보이는지 확인하기.

select date(invoicedate)
	   ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
group by date(invoicedate)
order by date(invoicedate);

# 1-2.국가별 매출 현황이 어떤 트렌드를 보이는지 확인하기.

select country
	   ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
group by country;

# 1-3. 국가별&제품별 매출 현황이 어떤 트렌드를 보이는지 확인하기

select country
	   ,stockcode
       ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
group by country
		,stockcode;
        
# 1-4.특정 제품(stockcode='21615')의 매출 현황을 확인하기

select sum(unitprice*quantity) as 매출액
	   ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
where stockcode='21615';

# 1-5.특정 제품(stockcode='21615','21731')의 기간별 매출 현황을 확인하기

select date(invoicedate) as invoicedate
	   ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
where stockcode in('21615','21731')
group by date(invoicedate);

###2. 이벤트 효과 분석

# 2-1.2011년 9월 10일부터 2011년 9월 25일까지 약 15일동안 진행한 이벤트의 매출 확인하기.

select case when invoicedate between '2011-09-10' and '2011-09-25' then '이벤트 기간'
			when  invoicedate between '2011-08-10' and '2011-08-25' then '이벤트 비교기간(전월동기간)' end as 기간구분
	   ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
where invoicedate between '2011-09-10' and '2011-09-25'
   or invoicedate between '2011-08-10' and '2011-08-25'
group by case when invoicedate between '2011-09-10' and '2011-09-25' then '이벤트 기간'
			  when invoicedate between '2011-08-10' and '2011-08-25' then '이벤트 비교기간(전월동기간)' end;
              
# 2-2.2011년 9월 10일부터 2011년 9월 25일까지 특정 제품(stockcode='17012A' 및 '17012C', '17021', '17084N')에
# 실시한 이벤트에 대해 해당 제품의 매출을 확인하기

select case when invoicedate between '2011-09-10' and '2011-09-25' then '이벤트 기간'
			when  invoicedate between '2011-08-10' and '2011-08-25' then '이벤트 비교기간(전월동기간)' end as 기간구분
	   ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
from sales
where ( invoicedate between '2011-09-10' and '2011-09-25'
   or invoicedate between '2011-08-10' and '2011-08-25')
   and stockcode in ( '17012A', '17012C', '17021', '17084N')
group by case when invoicedate between '2011-09-10' and '2011-09-25' then '이벤트 기간'
			  when invoicedate between '2011-08-10' and '2011-08-25' then '이벤트 비교기간(전월동기간)' end;
             
### 3.CRM 고객 타깃 출력
# 3-1. 2010년 12월 1일부터 2010년 12월 10일까지 특정제품(stockcode='21730' 및 '21615')을 구매한 고객 정보 확인하기.

select s.customerid
	   ,c.customer_name
       ,c.gd
       ,c.birth_dt
       ,c.entr_dt
       ,c.grade
       ,c.sign_up_ch
from   (
		select distinct customerid
        from sales
        where stockcode in('21730','21615')
        and invoicedate between '2010-12-01' and '2010-12-10'
        ) s
left
join    ( 
		 select mem_no
				,concat(last_name,first_name) as customer_name
                ,gd
                ,birth_dt
                ,entr_dt
                ,grade
                ,sign_up_ch
			from customer
            ) c
		on s.customerid=c.mem_no;
        
# 3-2.전체 멤버십 가입 고객 중에서 구매 이력이 없는 고객과 구매 이력이 있는 고객 정보 구분하기.

select case when s.customerid is null then c.mem_no end as non_purchaser
			,c.mem_no
            ,c.last_name
            ,c.first_name
            ,s.invoiceno
            ,s.stockcode
            ,s.quantity
            ,s.invoicedate
            ,s.unitprice
            ,s.customerid
from customer c
left
join sales s
  on c.mem_no=s.customerid;
  
# 3-3. 전체 고객수와 미고객수를 계산하기.

select count(distinct case when s.customerid is null then c.mem_no end) as non_purchaser
	   ,count(distinct c.mem_no) as total_customer
from customer c
left
join sales s
on c.mem_no=s.customerid;

### 4. 고객 상품 구매 패턴

# 4-1. A브랜드 매장의 매출 평균 지표를 파악하려면 각 요소에 대한 계산을 완료한 후 평균 지표 공식에 맞춰 나누기.

select sum(unitprice*quantity) as 매출액
	  ,sum(quantity) as 주문수량
      ,count(distinct invoiceno) as 주문건수
      ,count(distinct customerid) as 주문고객수
      
      ,sum(unitprice*quantity)/count(distinct invoiceno) as ATV
      ,sum(unitprice*quantity)/count(distinct customerid) as AMV
      ,count(distinct invoiceno)*1.00/count(distinct customerid)*1.00 as AvgFrq
      ,sum(quantity)*1.00/count(distinct invoiceno)*1.00 as AvgUnits
from sales;

#4-2. 연도 및 월별 매출 평균지표 ATV,AMV,Avg.Frq,Avg.Units의 값 파악하기.
select year(invoicedate) as 연도
	   ,month(invoicedate) as 월
       ,sum(unitprice*quantity) as 매출액
       ,sum(quantity) as 주문수량
       ,count(distinct invoiceno) as 주문건수
       ,count(distinct customerid) as 주문고객수
       
       ,sum(unitprice*quantity)/count(distinct invoiceno) as ATV
       ,sum(unitprice*quantity)/count(distinct customerid) as AMV
       ,count(distinct invoiceno)*1.00/count(distinct customerid)*1.00 as AvgFrq
       ,sum(quantity)*1.00/count(distinct invoiceno)*1.00 AS AvgUnits
from sales
group by year(invoicedate)
		,month(invoicedate)
order by 1,2;

###5. 베스트셀링 상품 확인

#5-1. 2011년에 가장 많이 판매된 제품 TOP10의 정보를 확인하기.

select stockcode
       ,description
       ,sum(quantity) as qty
from sales
where year(invoicedate)='2011'
group by stockcode
		,description
order by qty desc
limit 10;

#5-2. 국가별 베스트셀링 상품 확인
select row_number() over (partition by country order by qty desc) as rnk
	  ,country
      ,stockcode
      ,description
      ,qty
from  (
      select country
		     ,stockcode
             ,description
             ,sum(quantity) as qty
	  from sales
      group by country
			   ,stockcode
               ,description
	  ) a
order by 2,1;

#5-3.20대 여성 고객이 가장 많이 구매한 제품 TOP10의 정보 확인하기.
select *
from (
	 select row_number() over (order by qty desc) as rnk
		    ,stockcode
            ,description
            ,qty
	 from   (
			select stockcode
                   ,description
                   ,sum(quantity) as qty
			from sales s
            left
            join customer c
              on s.customerid=c.mem_no
			where c.gd='F'
             and 2023-year(c.birth_dt) between '20' and '29'
             group by stockcode
					 ,description) a
                     ) aa
			where rnk<=10;
            
### 6.장바구니 분석: 함께 구매한 제품 확인

#6-1.특정제품(stockcode='20275')과 함께 가장 많이 구매한 제품 TOP10 정보 확인하기.
select s.stockcode
	   ,s.description
       ,sum(quantity) as qty
from sales s
inner
join (
SELECT DISTINCT invoiceno
from sales
where stockcode='20725'
	 ) i
  on s.invoiceno=i.invoiceno
where s.stockcode <> '20725'
group by s.stockcode
		,s.description
order by qty desc
limit 10;   

#6-2. 특정제품(stockcode='20275')과 함께 가장 많이 구매한 제품 Top10의 정보 확인하기
#단, 이중에서 제품명에 LUNCH가 포함된 제품은 제외한다.
select s.stockcode
	   ,s.description
       ,sum(quantity) as qty
from sales s
inner
join (
SELECT DISTINCT invoiceno
from sales
where stockcode='20725'
	 ) i
  on s.invoiceno=i.invoiceno
where s.stockcode <> '20725'
and s.description not like '%LUNCH%'
group by s.stockcode
		,s.description
order by qty desc
limit 10;

###7. 재구매 지표

#7-1. 쇼핑몰의 재구매 고객수를 확인하기
select count(distinct customerid) as repurchaser_count
from (
	 select customerid,count(distinct invoicedate) as frq
     from sales
     where customerid <>''
     group by customerid
	 having count(distinct invoicedate)>=2
     ) a;
     
#7-2.특정제품(stockcode='21088')의 재고매 고객수와 구매일자 순서를 확인하기
select count(distinct customerid) as repurchaser_count
from (
	 select customerid,dense_rank() over (partition by customerid
     order by invoicedate) as rnk
     from sales
     where customerid <>''
     and stockcode='21088'
     ) a
     where rnk=2;
     
#7-3.2010년 구매 이력이 있는 고객들의 2011년 유지율을 확인하기.
SELECT COUNT(distinct  customerid) as retention_customer_count
from sales
where customerid <>''
and customerid in (select customerid
				   from sales
				   where customerid <>''
                   and year(invoicedate)='2010'
                   )
and year(invoicedate)='2011';

#7-4. 고객별로 첫 구매 이후 재구매까지의 구매기간을 확인하기.
select avg(purchase_period) as avg_purchase_period
from(
select aa.customerid as first_pur_customerid
		,aa.invoicedate as first_pur_invoicedate
        ,aa.day_no as first_pur_day_no
        ,bb.customerid as second_pur_customerid
        ,bb.invoicedate as second_pur_invoicedate
        ,bb.day_no as second_pur_day_no
        ,datediff(bb.invoicedate, aa.invoicedate) as purchase_period
from  (
       select customerid
			,invoicedate
			,dense_RANK() OVER (PARTITION BY customerid order by invoicedate) 
            as day_no
       from (
		 select customerid, invoicedate
         from sales
         where customerid <> ''
         group by customerid,invoicedate
		) a
      ) aa
left
join  (
		select customerid
			   ,invoicedate
               ,DENSE_RANK() OVER (partition by customerid order by invoicedate)
               as day_no
		from   (
				select customerid, invoicedate
                from sales
         where customerid <> ''
         group by customerid,invoicedate
		 ) b
	) bb
    on aa.customerid=bb.customerid and aa.day_no+1=bb.day_no
    where aa.day_no=1
    and bb.day_no=2
) aaa
                