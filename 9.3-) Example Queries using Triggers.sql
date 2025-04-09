--After trigger

--#1 : Add new columns for the number of workers, male workers, and female workers to the DEPARTMENT table.
ALTER TABLE DEPARTMENT	ADD NumberOfWorkers intALTER TABLE DEPARTMENT	ADD NumberOfFemaleWorkers intALTER TABLE DEPARTMENT	ADD NumberOfMaleWorkers int


--#2 : Update the number of workers, male workers, and female workers in each department.
UPDATE DEPARTMENTSET NumberOfWorkers =(		SELECT COUNT(*)		FROM WORKER  		JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID		WHERE WORKER.standInDepartmentNumber = DEPARTMENT.departmentNumber)UPDATE DEPARTMENTSET NumberOfMaleWorkers =(		SELECT COUNT(*)		FROM WORKER  		JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID		WHERE WORKER.standInDepartmentNumber = DEPARTMENT.departmentNumber AND EMPLOYEE.gender = 'male')UPDATE DEPARTMENTSET NumberOfFemaleWorkers =(		SELECT COUNT(*)		FROM WORKER  		JOIN EMPLOYEE ON WORKER.employeeID = EMPLOYEE.employeeID		WHERE WORKER.standInDepartmentNumber = DEPARTMENT.departmentNumber AND EMPLOYEE.gender = 'female')SELECT * FROM DEPARTMENT	--#3 INSERTED : Create a trigger to update the number of workers, male workers, and female workers in a department when a new worker is added.			GOCREATE TRIGGER tr_AddWorker
ON WORKER
FOR INSERT
AS
BEGINdeclare @Gender nvarchar(50)declare @DepartmentNo intselect  @Gender = EMPLOYEE.gender, @DepartmentNo = standInDepartmentNumber FROM insertedJOIN EMPLOYEE ON inserted.employeeID = EMPLOYEE.employeeIDUPDATE DEPARTMENTSET NumberOfWorkers = NumberOfWorkers + 1WHERE DEPARTMENT.departmentNumber = @DepartmentNoIF (@Gender = 'Male')
BEGIN
UPDATE DEPARTMENT
SET NumberOfMaleWorkers = NumberOfMaleWorkers + 1
WHERE departmentNumber = @DepartmentNo;
END

IF (@Gender = 'Female')
BEGIN
UPDATE DEPARTMENT
SET NumberOfFemaleWorkers = NumberOfFemaleWorkers + 1
WHERE departmentNumber = @DepartmentNo;
END
END;--#4--before execSELECT * FROM DEPARTMENT--execINSERT INTO EMPLOYEE (employeeID, firstName, lastName, gender)
VALUES (100, 'NEW', 'WORKER1', 'Female');INSERT INTO EMPLOYEE (employeeID, firstName, lastName, gender)
VALUES (101, 'NEW', 'WORKER2', 'Male');INSERT INTO WORKER (employeeID, standInDepartmentNumber)
VALUES (100, 101);INSERT INTO WORKER (employeeID, standInDepartmentNumber)
VALUES (101, 102);--after execSELECT * FROM DEPARTMENT--#4 DELETED : Create a trigger to update the number of workers, male workers, and female workers in a department when a worker is deleted.GOCREATE TRIGGER tr_DeleteWorker
ON WORKER
FOR DELETE
AS
BEGINdeclare @Gender nvarchar(50)declare @DepartmentNo intselect  @Gender = EMPLOYEE.gender, @DepartmentNo = standInDepartmentNumber FROM deletedJOIN EMPLOYEE ON deleted.employeeID = EMPLOYEE.employeeIDUPDATE DEPARTMENTSET NumberOfWorkers = NumberOfWorkers - 1WHERE DEPARTMENT.departmentNumber = @DepartmentNoIF (@Gender = 'Male')
BEGIN
UPDATE DEPARTMENT
SET NumberOfMaleWorkers = NumberOfMaleWorkers - 1
WHERE departmentNumber = @DepartmentNo;
END

IF (@Gender = 'Female')
BEGIN
UPDATE DEPARTMENT
SET NumberOfFemaleWorkers = NumberOfFemaleWorkers - 1
WHERE departmentNumber = @DepartmentNo;
END
END;--#5--before execSELECT * FROM DEPARTMENT--execDELETE FROM WORKERWHERE employeeID = 100DELETE FROM WORKERWHERE employeeID = 101

--after execSELECT * FROM DEPARTMENT