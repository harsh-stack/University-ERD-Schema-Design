# University Database Design (CIS Database Course)
[
[
[

Database Design Course assignment: Complete ER → Logical → Physical transformation of University Database using ERwin Data Modeler. Features 6 entities, 9 relationships (including M:N), referential integrity triggers, and production-ready DDL.
​

## 🎓 Assignment Overview
CIS Database Course Homework: Design University database with:

Conceptual → Logical → Physical models

ERwin diagrams (logical/physical)

M:N resolution (Student-Section → StudentSection)

Relationship attributes (Chair start date, Grade)

Full DDL generation with constraints/triggers

Learning Outcomes:

ER-to-relational mapping

Forward engineering

Referential integrity enforcement

SQL Server physical implementation
​

## 📊 Database Entities (6 Core + 1 Derived)
Entity	Primary Key	Key Attributes
Entity	Primary Key	Key Attributes
College	CName	Coffice, Cphone
Dept	DName, DCode	DOffice, DPhone
Instructor	Id	Rank, IName, IOffice
Course	CCode, CoName	Credits, Level, CDesc
Section	SecId	SecNo, Sem, Bldg, RoomNo
Student	SId	DOB, FName, LName, Major
StudentSection (M:N)	SId, SecId	Grade
Added: Chair entity (Instructor → Dept chair relationship)
​

## 🔗 Relationships (9 Binary + Constraints)
text
College 1:N Admins → Dept
Dept 1:N Offers → Course  
Dept 1:N Employs → Instructor
Dept 1:N Has → Student
Instructor 1:N Teaches → Section
Course 1:N Secs → Section
**Student M:N Takes → Section** (resolved)
Instructor 1:1 Chairs → Dept
9 FK constraints + cascade triggers prevent orphans


