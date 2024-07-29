CREATE TABLE Subject (
    SubjectID VARCHAR(50) PRIMARY KEY,
    Age INT,
    Gender CHAR(1),
    Height INT,
    Weight DECIMAL(4, 1),
    BMI DECIMAL(25, 20),
    Hand_Dominance VARCHAR(50),
    Foot_Dominance VARCHAR(50),
    Surgical_Side VARCHAR(50)
);

CREATE TABLE Cohort (
    CohortID SERIAL PRIMARY KEY,
    CohortName VARCHAR(50) UNIQUE
);

CREATE TABLE Subject_Cohort (
    SubjectCohortID SERIAL PRIMARY KEY,
    SubjectID VARCHAR NOT NULL,
    CohortID INT NOT NULL,
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID),
    FOREIGN KEY (CohortID) REFERENCES Cohort(CohortID)
);

CREATE TABLE Time_Period (
    Time_PeriodID SERIAL PRIMARY KEY,
    Time_Period_Name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE SubjectCohort_TimePeriod (
    SubjectCohortTimePeriodID SERIAL PRIMARY KEY,
    SubjectCohortID INT NOT NULL,
    Time_PeriodID INT NOT NULL,
    FOREIGN KEY (SubjectCohortID) REFERENCES Subject_Cohort(SubjectCohortID),
    FOREIGN KEY (Time_PeriodID) REFERENCES Time_Period(Time_PeriodID),
	UNIQUE (SubjectCohortID, Time_PeriodID)
);

CREATE TABLE Activity (
    ActivityID SERIAL PRIMARY KEY,
    ActivityName VARCHAR(50) UNIQUE
);

CREATE TABLE Phase (
    PhaseID SERIAL PRIMARY KEY,
    SubjectCohortTimePeriodID INT NOT NULL,
    ActivityID INT NOT NULL,
    PhaseNumber INT NOT NULL,
	Time DECIMAL(25, 20),
    FOREIGN KEY (SubjectCohortTimePeriodID) REFERENCES SubjectCohort_TimePeriod(SubjectCohortTimePeriodID),
    FOREIGN KEY (ActivityID) REFERENCES Activity(ActivityID),
	UNIQUE (SubjectCohortTimePeriodID, ActivityID, PhaseNumber)
);

CREATE TABLE MeasurementType (
    MeasurementTypeID SERIAL PRIMARY KEY,
    MeasurementTypeName VARCHAR(50) UNIQUE
);

CREATE TABLE BodyPart (
    BodyPartID SERIAL PRIMARY KEY,
    BodyPartName VARCHAR(50) UNIQUE
);

CREATE TABLE Measurement (
    MeasurementID SERIAL PRIMARY KEY,
    PhaseID INT NOT NULL,
    BodyPartID INT NOT NULL,
    MeasurementTypeID INT NOT NULL,
    Start_Value DECIMAL(25, 20),
    End_Value DECIMAL(25, 20),
    Max_Value DECIMAL(25, 20),
    Min_Value DECIMAL(25, 20),
    ROM_Value DECIMAL(25, 20),
    FOREIGN KEY (PhaseID) REFERENCES Phase(PhaseID),
    FOREIGN KEY (BodyPartID) REFERENCES BodyPart(BodyPartID),
    FOREIGN KEY (MeasurementTypeID) REFERENCES MeasurementType(MeasurementTypeID),
    UNIQUE (PhaseID, BodyPartID, MeasurementTypeID)
);

-- select * from cohort
-- order by cohortname;

-- select * from subject;

-- select * from Subject_Cohort;

-- select * from Time_Period;

-- select * from SubjectCohort_TimePeriod;

-- select * from Activity;

-- select * from Phase;

-- select * from BodyPart;

-- select * from MeasurementType;

-- select * from Measurement;

-- -- Get All Phases for a Specific Subject
-- SELECT Phase.*
-- FROM Phase
-- JOIN SubjectCohort_TimePeriod ON Phase.SubjectCohortTimePeriodID = SubjectCohort_TimePeriod.SubjectCohortTimePeriodID
-- JOIN Subject_Cohort ON SubjectCohort_TimePeriod.SubjectCohortID = Subject_Cohort.SubjectCohortID
-- WHERE Subject_Cohort.SubjectID = 'C0030';

-- -- Get Measurements for a Specific Phase
-- SELECT Measurement.*, BodyPart.BodyPartName, MeasurementType.MeasurementTypeName
-- FROM Measurement
-- JOIN BodyPart ON Measurement.BodyPartID = BodyPart.BodyPartID
-- JOIN MeasurementType ON Measurement.MeasurementTypeID = MeasurementType.MeasurementTypeID
-- WHERE Measurement.PhaseID = 1;

-- -- Get All Measurements for a Specific Subject in a Specific Time Period
-- SELECT Measurement.*, BodyPart.BodyPartName, MeasurementType.MeasurementTypeName, Phase.PhaseNumber, Time_Period.Time_Period_Name
-- FROM Measurement
-- JOIN Phase ON Measurement.PhaseID = Phase.PhaseID
-- JOIN SubjectCohort_TimePeriod ON Phase.SubjectCohortTimePeriodID = SubjectCohort_TimePeriod.SubjectCohortTimePeriodID
-- JOIN Time_Period ON SubjectCohort_TimePeriod.Time_PeriodID = Time_Period.Time_PeriodID
-- JOIN Subject_Cohort ON SubjectCohort_TimePeriod.SubjectCohortID = Subject_Cohort.SubjectCohortID
-- JOIN BodyPart ON Measurement.BodyPartID = BodyPart.BodyPartID
-- JOIN MeasurementType ON Measurement.MeasurementTypeID = MeasurementType.MeasurementTypeID
-- WHERE Subject_Cohort.SubjectID = 'C0030' AND Time_Period.Time_Period_Name = 'Pre00';

-- -- List All Subjects in a Specific Cohort
-- SELECT Subject.*
-- FROM Subject
-- JOIN Subject_Cohort ON Subject.SubjectID = Subject_Cohort.SubjectID
-- JOIN Cohort ON Subject_Cohort.CohortID = Cohort.CohortID
-- WHERE Cohort.CohortName = 'SHL1';

-- -- Find All Phases and Their Activities for a Specific Subject in a Specific Time Period
-- SELECT Phase.*, Activity.ActivityName
-- FROM Phase
-- JOIN Activity ON Phase.ActivityID = Activity.ActivityID
-- JOIN SubjectCohort_TimePeriod ON Phase.SubjectCohortTimePeriodID = SubjectCohort_TimePeriod.SubjectCohortTimePeriodID
-- JOIN Subject_Cohort ON SubjectCohort_TimePeriod.SubjectCohortID = Subject_Cohort.SubjectCohortID
-- JOIN Time_Period ON SubjectCohort_TimePeriod.Time_PeriodID = Time_Period.Time_PeriodID
-- WHERE Subject_Cohort.SubjectID = 'C0030' AND Time_Period.Time_Period_Name = 'Pre00';

-- -- Get Average ROM Value for Each Body Part Across All Subjects
-- SELECT BodyPart.BodyPartName, AVG(Measurement.ROM_Value) AS Average_ROM
-- FROM Measurement
-- JOIN BodyPart ON Measurement.BodyPartID = BodyPart.BodyPartID
-- GROUP BY BodyPart.BodyPartName;

-- -- Get All Measurements for a Specific Subject and Cohort
-- SELECT Measurement.*, BodyPart.BodyPartName, MeasurementType.MeasurementTypeName
-- FROM Measurement
-- JOIN Phase ON Measurement.PhaseID = Phase.PhaseID
-- JOIN SubjectCohort_TimePeriod ON Phase.SubjectCohortTimePeriodID = SubjectCohort_TimePeriod.SubjectCohortTimePeriodID
-- JOIN Subject_Cohort ON SubjectCohort_TimePeriod.SubjectCohortID = Subject_Cohort.SubjectCohortID
-- JOIN BodyPart ON Measurement.BodyPartID = BodyPart.BodyPartID
-- JOIN MeasurementType ON Measurement.MeasurementTypeID = MeasurementType.MeasurementTypeID
-- WHERE Subject_Cohort.SubjectID = 'C0030' AND Subject_Cohort.CohortID = (SELECT CohortID FROM Cohort WHERE CohortName = 'SHL1');
