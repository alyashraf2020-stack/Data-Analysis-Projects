create database students 
use students
create Schema st
create Schema le
-------------------------------
--Q1 Write a query to display gender, age, education level, and internet type for all students--
select s.Gender,s.Age,l.Education_Level,l.Internet_Type
from st.Students as s inner join le.learning as l on s.Student_id = l.student_id
-------------------------------------------------------------------------------------------
--Q2 Display all students who use Wifi and have Moderate adaptivity level. Show gender, education level, and device--
select s.Gender , l.Education_Level ,l.Device
from st.Students as s inner join le.learning as l on s.Student_id = l.student_id 
where Internet_Type = 'Wifi' and Adaptivity_Level = 'Moderate'
--------------------------------------------------------------------------------------------
--Q3 Show all school students who use Mobile Data and have Low adaptivity level. Display gender, age, and network type--
select s.Gender,s.Age, l.Network_Type
from st.Students as s inner join le.learning as l on s.Student_id = l.student_id
where Internet_Type='Mobile data' and Adaptivity_Level='low'
--------------------------------------------------------------------------------------------
--Q4 Display the number of students for each internet type and network type--
select Internet_Type,network_type ,COUNT(student_id) as num_of_st
from le.learning
group by internet_type , network_type
-----------------------------------------------------------------------------------------------
--Q5 Show education level, device, and number of students. Include only students who have Poor OR Mid financial condition--
select Education_Level,Device,COUNT(student_id) as num_of_st
from le.learning
where Financial_Condition in ('Poor' , 'Mid')
group by Education_Level,Device
-------------------------------------------------------------------------------------------------
--Q6 Display education level and the average class duration for each education level. Only show education levels where the average class duration is greater than 1 hour--
SELECT Education_Level, AVG(class_Duration_Numeric) AS Avg_Class_Duration
FROM le.learning
GROUP BY Education_Level
HAVING AVG(class_Duration_Numeric) > 1
-------------------------------------------------------------------------------------------------
--Q7 Display device and the count of students. Only include devices that are used by more than one student.
ALTER TABLE le.learning
alter column class_Duration_Numeric DECIMAL(4,1)

update le.learning
set class_Duration_Numeric =
case
    when Class_Duration='1-3' then 2.5
    when Class_Duration='3-6' then 4.5
    else 0

end

select Device,COUNT(student_id) as total_students
from le.learning
group by Device
having COUNT(student_id)>1
-----------------------------------------------------------------------------------------------------
--Q8 Write a query using CASE to create a new column called Internet_Quality: 
--• If Internet Type is Wifi and Network Type is 4G, show Good 
--•Otherwise, show Limited Display gender, education level, internet type, network type, and Internet_Quality

alter table le.learning
add Internet_Quality varchar(15)

update le.learning
set Internet_Quality=
case
   when Internet_Type='Wifi' and Network_Type='4G' then 'Good'
   else 'Limited'
end

select s.Gender,l.Education_Level,l.Internet_Type,l.Network_Type,l.Internet_Quality
from st.Students as s inner join le.learning as l on s.Student_id =l.student_id
-----------------------------------------------------------------------------------------------------
--Q9 Create a VIEW called connected_students that includes students who:
--• Have Location = Yes
--• AND use Wifi Then display all records from the view ordered by Adaptivity Level

create view connected_students 
as
select student_id,Adaptivity_Level
from le.learning
where Location =1 and Internet_Type='Wifi'

select *
from connected_students
order by adaptivity_level
-------------------------------------------------------------------------------------------------------
--Q10 For each education level, display:
--• Total number of students 
--• Number of students with Low adaptivity level Only show education levels where more than 30% of students have Low adaptivity level.

WITH cte AS
(
    SELECT
        Education_Level,
        COUNT(Student_id) AS total_students,
        COUNT(CASE WHEN Adaptivity_Level = 'Low' THEN Student_id END) AS low_students
    FROM le.learning
    GROUP BY Education_Level
)

SELECT
    Education_Level,
    total_students,
    low_students
FROM cte
WHERE low_students * 1.0 / total_students > 0.30;
-----------------------------------------------------------------------------------------------------------------------------
select education_level,count(student_id) as Total_Students,COUNT(case when adaptivity_level='low' then 1 end) as low_students
from le.learning
group by education_level
having COUNT(case when adaptivity_level='low' then 1 end)*1.0 /count(student_id)>0.30
-------------------------------------------------------------------------------------------------------------------------------