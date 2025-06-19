/*Total Loan Applications: We need to calculate the total number of loan applications received during a 
specified period. Additionally, it is essential to monitor the Month-to-Date (MTD) Loan Applications and track 
changes Month-over-Month (MoM).--*/

--Total Loan Applications--
select * from bank_loan_data;

select count(id) as total_loan_application from bank_loan_data;

select count(id) as MTD_total_loan_application from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021;

select count(id) as PMTD_total_loan_application from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021;

/*Total Funded Amount: Understanding the total amount of funds disbursed as loans is crucial. 
We also want to keep an eye on the MTD Total Funded Amount and analyse the Month-over-Month (MoM) changes in this metric.*/

--Total Funded Amound--
select sum(loan_amount) as MTD_Total_founded_amount from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

select sum(loan_amount) as PMTD_Total_founded_amount from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

/*Total Amount Received: Tracking the total amount received from borrowers is essential 
for assessing the bank's cash flow and loan repayment. 
We should analyse the Month-to-Date (MTD) Total Amount Received and observe the Month-over-Month (MoM) changes.*/

--Total amount received--
select * from bank_loan_data;

select sum(total_payment) as MTD_total_amount_received from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

select sum(total_payment) as PMTD_total_amount_received from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

/*Average Interest Rate: Calculating the average interest rate across all loans, MTD, and monitoring the Month-over-Month (MoM) 
variations in interest rates will provide insights into our lending portfolio's overall cost.*/

--Average interest rate--
select * from bank_loan_data

select round(avg(int_rate), 4) * 100 as avg_interest_rate from bank_loan_data

select round(avg(int_rate), 4) * 100 as MTD_avg_interest_rate from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

select round(avg(int_rate), 4) * 100 as PMTD_avg_interest_rate from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

/*Average Debt-to-Income Ratio (DTI): Evaluating the average DTI for our borrowers helps us gauge their financial health. 
We need to compute the average DTI for all loans, MTD, and track Month-over-Month (MoM) fluctuations.*/

--Avergae dept-to-income ratio (DTI)--
select column_name from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'bank_loan_data' and COLUMN_NAME like '%dti%' --Finding the column we are looking for the analysis--

select dti from bank_loan_data

select round(avg(dti), 4) as avg_dept_to_income from bank_loan_data

select round(avg(dti), 4) as MTD_avg_dept_to_income from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

select round(avg(dti), 4) as PMTD_avg_dept_to_income from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

/*Good Loan v Bad Loan KPI’s*/

--Good Loan--
--Good Loan Application Percentage--
select column_name from INFORMATION_SCHEMA.columns
where TABLE_NAME = 'bank_loan_data' and COLUMN_NAME like '%loan%'

select distinct loan_status from bank_loan_data

select round((cast(count(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id end) as float)/count(id)) * 100, 2)
as percentage_goodloan from bank_loan_data

--Good loan application--
--First Option--
select count(id) Number_of_application from bank_loan_data
where loan_status in ('Fully Paid', 'Current')
--Second Option--
select count(id) Number_of_application from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

--Good Loan Funded Amount--
select column_name as column_searching
from INFORMATION_SCHEMA.columns where TABLE_NAME = 'bank_loan_data' and column_name like '%loan%'

select sum(loan_amount) Good_loan_funded_amount from bank_loan_data
where loan_status in ('Fully Paid', 'Current')

--Good Loan Total Received Amount--

select column_name as seak_column from INFORMATION_SCHEMA.COLUMNS where table_name = 'bank_loan_data' and COLUMN_NAME like '%tota%'

select sum(total_payment) as total_received_amount from bank_loan_data where loan_status in ('Fully Paid', 'Current')

--Bad Loan--
--Bad Loan Application Percentage--
select column_name as searching_column from INFORMATION_SCHEMA.columns where table_name = 'bank_loan_data' and column_name like '%loan%'

select distinct loan_status from bank_loan_data

select round((cast(count(case when loan_status = 'Charged Off' then id end) as float) / count(id)), 4) * 100 as percentage_bad_loan from bank_loan_data

--Bad Loan Applications--
select column_name from INFORMATION_SCHEMA.columns where table_name = 'bank_loan_data' and column_name like '%status%'

select count(id) as bad_loan_application from bank_loan_data where loan_status = 'Charged Off'

--Bad Loan Funded Amount--
select * from bank_loan_data

select column_name from INFORMATION_SCHEMA.COLUMNS where table_name = 'bank_loan_data' and column_name like '%loan%'

select sum(loan_amount) as total_bad_loan_funded_amount from bank_loan_data where loan_status = 'Charged Off'

--Bad Loan Total Received Amount--
select * from bank_loan_data

select column_name from INFORMATION_SCHEMA.columns where table_name = 'bank_loan_data' and COLUMN_NAME like '%paymen%'

select sum(total_payment) as total_bad_loan_received_amount from bank_loan_data where loan_status = 'Charged Off'


/* 
In order to gain comprehensive overview of our landing operations and monitoring the performance of loans
we aim to create a grid view report categorized by loan status
By providing insight into metrics such as total loan application, total funded amound, total amount received, Month to Date(MTD)
funded amount, MTD amount received, AVG Interest rate, 
This grid overview will help us assess the heath of our loan portfolio 
*/

--List of metrics--
--total loan application, total funded amount, total amount received, MTD funded amount, MTD amount received, AVG Interest Rate--
select * from bank_loan_data

select column_name from INFORMATION_SCHEMA.columns where table_name = 'bank_loan_data' and column_name like '%pay%'

select
	loan_status,
	format(count(id), 'N0') as total_loan_application,
	format(sum(loan_amount), 'N0') as total_loan_amount,
	format(sum(total_payment), 'N0') as total_payment,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end), 'N0') as MTD_total_funded_amount12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end), 'N0') as MTD_total_payment_12_21,
	format(avg(dti), 'N2') as avg_interest_rate_DTI
from bank_loan_data
group by loan_status

-- Monthly trend by issue date --
/*to identify seasonal and long-term trends analysis by state (filed map)*/
select column_name from information_schema.columns where table_name = 'bank_loan_data' and COLUMN_NAME like '%term%'
select * from bank_loan_data
select
	month(issue_date) as month_number,
	datename(month, issue_date) as month_as_name,
	format(count(id), 'N0') as total_loan_application,
	format(sum(loan_amount), 'N0') as total_loan_amount,
	format(sum(total_payment), 'N0') as total_payment,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end), 'N0') as MTD_total_funded_amount12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end), 'N0') as MTD_total_payment_12_21,
	format(avg(dti), 'N2') as avg_interest_rate_DTI
from bank_loan_data
group by month(issue_date), datename(month, issue_date)
order by month_number offset 0 row fetch next 5 rows only
/*Regional analysis by state (e.g: filled Map) [to identify regions with significant lending activity and 
assess regional disparities]*/
select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'bank_loan_data' and column_name like '%state%';
select distinct address_state from bank_loan_data order by address_state
select * from bank_loan_data
select
	address_state,
	count(id) as Total_loan_application,
	sum(loan_amount) as total_loan_amount,
	sum(total_payment) as total_payment,
	sum(dti) as interest_rate_loan,
	sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then dti else 0 end) as MTD_interest_rate_dti,
	sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as MTD_total_loan_amount,
	sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as MTD_total_payment
from bank_loan_data
group by address_state
order by Total_loan_application desc

/*Loan term analysis (e.g: barchart) to allow the clients understand the distribution of loan accross different term
lenghts*/
/*We wanna Identify seasonal and long term trends in a lenghty activities*/
select column_name from information_schema.columns where table_name = 'bank_loan_data' and COLUMN_NAME like '%term%'
select distinct term from bank_loan_data
select
	term,
	format(count(id), 'N0') as total_loan_application,
	format(sum(loan_amount), 'N0') as total_loan_amount,
	format(sum(total_payment), 'N0') as total_payment,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end), 'N0') as MTD_total_funded_amount12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end), 'N0') as MTD_total_payment_12_21,
	format(avg(dti), 'N2') as avg_interest_rate_DTI
from bank_loan_data
group by term

/*Employee lenght analysis(e.g: Bar chart) [How lending metrics are didtibuted among borrower 
with different employment lenghts, helping us access the impact of impact employment history on loan applications]*/
select column_name from information_schema.columns where table_name = 'bank_loan_data' and column_name like '%emp%'
select emp_length, emp_title from bank_loan_data
select 
	emp_length,
	format(count(id), 'N0') as total_loan_application,
	format(sum(loan_amount), 'N0') as total_loan_amount,
	format(sum(total_payment), 'N0') as total_payment,
	format(avg(dti), 'N2') as avg_interest_rate_DTI,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end), 'N0') as MTD_total_funded_amount12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end), 'N0') as MTD_total_payment_12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then dti else 0 end), 'N0') as MTD_Dette_rate_interest
from bank_loan_data
group by emp_length
order by total_loan_application desc
select * from bank_loan_data

/*Loan purpose breakdown (e.g: bar chart) [breakdown of loan metrics based on stated purposes of loan] */
select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'bank_loan_data' and COLUMN_NAME like '%purpose%'
select loan_status,loan_amount from bank_loan_data
select
	purpose,
    format(count(id), 'N0') as total_loan_application,
	format(sum(loan_amount), 'N0') as total_loan_amount,
	format(sum(total_payment), 'N0') as total_payment,
	format(avg(loan_amount), 'N2') as avg_loan_,
	format(avg(dti), 'N2') as avg_interest_rate_DTI,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end), 'N0') as MTD_total_funded_amount12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end), 'N0') as MTD_total_payment_12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then dti else 0 end), 'N0') as MTD_Dette_rate_interest
from bank_loan_data
group by purpose
order by count(id) desc
/*Home ownership analysis (e.g: Tree Map) How home ownership impacts loan applications and disbursments*/
select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'bank_loan_data' and COLUMN_NAME like '%owner%'
select distinct home_ownership from bank_loan_data
select
	home_ownership,
	format(count(id), 'N0') as total_loan_application,
	format(sum(loan_amount), 'N0') as total_loan_amount,
	format(sum(total_payment), 'N0') as total_payment,
	format(avg(loan_amount), 'N2') as avg_loan_,
	format(avg(dti), 'N2') as avg_interest_rate_DTI,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end), 'N0') as MTD_total_funded_amount12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end), 'N0') as MTD_total_payment_12_21,
	format(sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then dti else 0 end), 'N0') as MTD_Dette_rate_interest
from bank_loan_data
group by home_ownership
order by total_loan_application

