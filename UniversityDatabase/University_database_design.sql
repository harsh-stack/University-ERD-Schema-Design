
CREATE TABLE [Chair]
( 
	[CStartDate]         char(18)  NULL ,
	[DName__FK_]         char(18)  NULL ,
	[DCode__FK_]         char(18)  NULL ,
	[Id__FK_]            char(18)  NULL 
)
go

CREATE TABLE [College]
( 
	[CName]              char(18)  NOT NULL ,
	[Coffice]            char(18)  NULL ,
	[Cphone]             char(18)  NULL ,
	[Id__FK_]            char(18)  NULL 
)
go

CREATE TABLE [Course]
( 
	[CCode]              char(18)  NOT NULL ,
	[CoName]             char(18)  NOT NULL ,
	[Credits]            char(18)  NULL ,
	[Level]              char(18)  NULL ,
	[CDesc]              char(18)  NULL ,
	[DName__FK_]         char(18)  NULL ,
	[DCode__FK_]         char(18)  NULL ,
	[DName]              char(18)  NULL ,
	[DCode]              char(18)  NULL 
)
go

CREATE TABLE [Dept]
( 
	[DName]              char(18)  NOT NULL ,
	[DCode]              char(18)  NOT NULL ,
	[DOffice]            char(18)  NULL ,
	[DPhone]             char(18)  NULL ,
	[CName__FK_]         char(18)  NULL ,
	[CName]              char(18)  NULL 
)
go

CREATE TABLE [Instructor]
( 
	[Id]                 char(18)  NOT NULL ,
	[Rank]               char(18)  NULL ,
	[IName]              char(18)  NULL ,
	[IOffice]            char(18)  NULL ,
	[IPhone]             char(18)  NULL ,
	[DName__FK_]         char(18)  NULL ,
	[DCode__FK_]         char(18)  NULL ,
	[DName]              char(18)  NULL ,
	[DCode]              char(18)  NULL 
)
go

CREATE TABLE [Section]
( 
	[SecId]              char(18)  NOT NULL ,
	[SecNo]              char(18)  NULL ,
	[Sem]                char(18)  NULL ,
	[Year]               char(18)  NULL ,
	[Bldg]               char(18)  NULL ,
	[RoomNo]             char(18)  NULL ,
	[DaysTime]           char(18)  NULL ,
	[CCode__FK_]         char(18)  NULL ,
	[CoName__FK_]        char(18)  NULL ,
	[Id__FK_]            char(18)  NULL ,
	[CCode]              char(18)  NULL ,
	[CoName]             char(18)  NULL ,
	[Id]                 char(18)  NULL 
)
go

CREATE TABLE [Student]
( 
	[SId]                char(18)  NOT NULL ,
	[DOB]                char(18)  NULL ,
	[FName]              char(18)  NULL ,
	[MName]              char(18)  NULL ,
	[LName]              char(18)  NULL ,
	[Addr]               char(18)  NULL ,
	[Phone]              char(18)  NULL ,
	[Major]              char(18)  NULL ,
	[DName__FK_]         char(18)  NULL ,
	[DCode__FK_]         char(18)  NULL ,
	[DName]              char(18)  NULL ,
	[DCode]              char(18)  NULL 
)
go

CREATE TABLE [Student_Section]
( 
	[SId]                char(18)  NOT NULL ,
	[SecId]              char(18)  NOT NULL ,
	[Grade]              varchar(2)  NULL 
)
go

ALTER TABLE [College]
	ADD CONSTRAINT [XPKCollege] PRIMARY KEY  CLUSTERED ([CName] ASC)
go

ALTER TABLE [Course]
	ADD CONSTRAINT [XPKCourse] PRIMARY KEY  CLUSTERED ([CCode] ASC,[CoName] ASC)
go

ALTER TABLE [Dept]
	ADD CONSTRAINT [XPKDept] PRIMARY KEY  CLUSTERED ([DName] ASC,[DCode] ASC)
go

ALTER TABLE [Instructor]
	ADD CONSTRAINT [XPKInstructor] PRIMARY KEY  CLUSTERED ([Id] ASC)
go

ALTER TABLE [Section]
	ADD CONSTRAINT [XPKSection] PRIMARY KEY  CLUSTERED ([SecId] ASC)
go

ALTER TABLE [Student]
	ADD CONSTRAINT [XPKStudent] PRIMARY KEY  CLUSTERED ([SId] ASC)
go

ALTER TABLE [Student_Section]
	ADD CONSTRAINT [XPKStudent_Section] PRIMARY KEY  CLUSTERED ([SId] ASC,[SecId] ASC)
go


ALTER TABLE [Course]
	ADD CONSTRAINT [R_27] FOREIGN KEY ([DName],[DCode]) REFERENCES [Dept]([DName],[DCode])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Dept]
	ADD CONSTRAINT [R_24] FOREIGN KEY ([CName]) REFERENCES [College]([CName])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Instructor]
	ADD CONSTRAINT [R_26] FOREIGN KEY ([DName],[DCode]) REFERENCES [Dept]([DName],[DCode])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Section]
	ADD CONSTRAINT [R_31] FOREIGN KEY ([CCode],[CoName]) REFERENCES [Course]([CCode],[CoName])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Section]
	ADD CONSTRAINT [R_32] FOREIGN KEY ([Id]) REFERENCES [Instructor]([Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Student]
	ADD CONSTRAINT [R_29] FOREIGN KEY ([DName],[DCode]) REFERENCES [Dept]([DName],[DCode])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Student_Section]
	ADD CONSTRAINT [R_35] FOREIGN KEY ([SId]) REFERENCES [Student]([SId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Student_Section]
	ADD CONSTRAINT [R_36] FOREIGN KEY ([SecId]) REFERENCES [Section]([SecId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_College ON College FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on College */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* College ADMINS Dept on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0000fa6b", PARENT_OWNER="", PARENT_TABLE="College"
    CHILD_OWNER="", CHILD_TABLE="Dept"
    P2C_VERB_PHRASE="ADMINS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="CName" */
    IF EXISTS (
      SELECT * FROM deleted,Dept
      WHERE
        /*  %JoinFKPK(Dept,deleted," = "," AND") */
        Dept.CName = deleted.CName
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete College because Dept exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_College ON College FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on College */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCName char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* College ADMINS Dept on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00011ac4", PARENT_OWNER="", PARENT_TABLE="College"
    CHILD_OWNER="", CHILD_TABLE="Dept"
    P2C_VERB_PHRASE="ADMINS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="CName" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CName)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Dept
      WHERE
        /*  %JoinFKPK(Dept,deleted," = "," AND") */
        Dept.CName = deleted.CName
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update College because Dept exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Course ON Course FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Course */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Course SECS Section on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00023d10", PARENT_OWNER="", PARENT_TABLE="Course"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="SECS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="CCode""CoName" */
    IF EXISTS (
      SELECT * FROM deleted,Section
      WHERE
        /*  %JoinFKPK(Section,deleted," = "," AND") */
        Section.CCode = deleted.CCode AND
        Section.CoName = deleted.CoName
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Course because Section exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Dept OFFERS Course on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Course"
    P2C_VERB_PHRASE="OFFERS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="DName""DCode" */
    IF EXISTS (SELECT * FROM deleted,Dept
      WHERE
        /* %JoinFKPK(deleted,Dept," = "," AND") */
        deleted.DName = Dept.DName AND
        deleted.DCode = Dept.DCode AND
        NOT EXISTS (
          SELECT * FROM Course
          WHERE
            /* %JoinFKPK(Course,Dept," = "," AND") */
            Course.DName = Dept.DName AND
            Course.DCode = Dept.DCode
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Course because Dept exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Course ON Course FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Course */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCCode char(18), 
           @insCoName char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Course SECS Section on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002a9b4", PARENT_OWNER="", PARENT_TABLE="Course"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="SECS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="CCode""CoName" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CCode) OR
    UPDATE(CoName)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Section
      WHERE
        /*  %JoinFKPK(Section,deleted," = "," AND") */
        Section.CCode = deleted.CCode AND
        Section.CoName = deleted.CoName
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Course because Section exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Dept OFFERS Course on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Course"
    P2C_VERB_PHRASE="OFFERS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="DName""DCode" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(DName) OR
    UPDATE(DCode)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Dept
        WHERE
          /* %JoinFKPK(inserted,Dept) */
          inserted.DName = Dept.DName and
          inserted.DCode = Dept.DCode
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.DName IS NULL AND
      inserted.DCode IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Course because Dept does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Dept ON Dept FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Dept */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Dept HAS Student on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00041254", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Student"
    P2C_VERB_PHRASE="HAS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="DName""DCode" */
    IF EXISTS (
      SELECT * FROM deleted,Student
      WHERE
        /*  %JoinFKPK(Student,deleted," = "," AND") */
        Student.DName = deleted.DName AND
        Student.DCode = deleted.DCode
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Dept because Student exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Dept OFFERS Course on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Course"
    P2C_VERB_PHRASE="OFFERS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="DName""DCode" */
    IF EXISTS (
      SELECT * FROM deleted,Course
      WHERE
        /*  %JoinFKPK(Course,deleted," = "," AND") */
        Course.DName = deleted.DName AND
        Course.DCode = deleted.DCode
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Dept because Course exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Dept EMPLOYS Instructor on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Instructor"
    P2C_VERB_PHRASE="EMPLOYS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="DName""DCode" */
    IF EXISTS (
      SELECT * FROM deleted,Instructor
      WHERE
        /*  %JoinFKPK(Instructor,deleted," = "," AND") */
        Instructor.DName = deleted.DName AND
        Instructor.DCode = deleted.DCode
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Dept because Instructor exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* College ADMINS Dept on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="College"
    CHILD_OWNER="", CHILD_TABLE="Dept"
    P2C_VERB_PHRASE="ADMINS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="CName" */
    IF EXISTS (SELECT * FROM deleted,College
      WHERE
        /* %JoinFKPK(deleted,College," = "," AND") */
        deleted.CName = College.CName AND
        NOT EXISTS (
          SELECT * FROM Dept
          WHERE
            /* %JoinFKPK(Dept,College," = "," AND") */
            Dept.CName = College.CName
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Dept because College exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Dept ON Dept FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Dept */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insDName char(18), 
           @insDCode char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Dept HAS Student on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004cae1", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Student"
    P2C_VERB_PHRASE="HAS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="DName""DCode" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(DName) OR
    UPDATE(DCode)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Student
      WHERE
        /*  %JoinFKPK(Student,deleted," = "," AND") */
        Student.DName = deleted.DName AND
        Student.DCode = deleted.DCode
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Dept because Student exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Dept OFFERS Course on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Course"
    P2C_VERB_PHRASE="OFFERS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="DName""DCode" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(DName) OR
    UPDATE(DCode)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Course
      WHERE
        /*  %JoinFKPK(Course,deleted," = "," AND") */
        Course.DName = deleted.DName AND
        Course.DCode = deleted.DCode
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Dept because Course exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Dept EMPLOYS Instructor on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Instructor"
    P2C_VERB_PHRASE="EMPLOYS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="DName""DCode" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(DName) OR
    UPDATE(DCode)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Instructor
      WHERE
        /*  %JoinFKPK(Instructor,deleted," = "," AND") */
        Instructor.DName = deleted.DName AND
        Instructor.DCode = deleted.DCode
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Dept because Instructor exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* College ADMINS Dept on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="College"
    CHILD_OWNER="", CHILD_TABLE="Dept"
    P2C_VERB_PHRASE="ADMINS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="CName" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CName)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,College
        WHERE
          /* %JoinFKPK(inserted,College) */
          inserted.CName = College.CName
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CName IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Dept because College does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Instructor ON Instructor FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Instructor */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Instructor TEACHES Section on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000238ba", PARENT_OWNER="", PARENT_TABLE="Instructor"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="TEACHES", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Id" */
    IF EXISTS (
      SELECT * FROM deleted,Section
      WHERE
        /*  %JoinFKPK(Section,deleted," = "," AND") */
        Section.Id = deleted.Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Instructor because Section exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Dept EMPLOYS Instructor on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Instructor"
    P2C_VERB_PHRASE="EMPLOYS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="DName""DCode" */
    IF EXISTS (SELECT * FROM deleted,Dept
      WHERE
        /* %JoinFKPK(deleted,Dept," = "," AND") */
        deleted.DName = Dept.DName AND
        deleted.DCode = Dept.DCode AND
        NOT EXISTS (
          SELECT * FROM Instructor
          WHERE
            /* %JoinFKPK(Instructor,Dept," = "," AND") */
            Instructor.DName = Dept.DName AND
            Instructor.DCode = Dept.DCode
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Instructor because Dept exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Instructor ON Instructor FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Instructor */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Instructor TEACHES Section on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00029c06", PARENT_OWNER="", PARENT_TABLE="Instructor"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="TEACHES", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Section
      WHERE
        /*  %JoinFKPK(Section,deleted," = "," AND") */
        Section.Id = deleted.Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Instructor because Section exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Dept EMPLOYS Instructor on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Instructor"
    P2C_VERB_PHRASE="EMPLOYS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="DName""DCode" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(DName) OR
    UPDATE(DCode)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Dept
        WHERE
          /* %JoinFKPK(inserted,Dept) */
          inserted.DName = Dept.DName and
          inserted.DCode = Dept.DCode
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.DName IS NULL AND
      inserted.DCode IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Instructor because Dept does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Section ON Section FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Section */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Section  Student_Section on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003839f", PARENT_OWNER="", PARENT_TABLE="Section"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="SecId" */
    IF EXISTS (
      SELECT * FROM deleted,Student_Section
      WHERE
        /*  %JoinFKPK(Student_Section,deleted," = "," AND") */
        Student_Section.SecId = deleted.SecId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Section because Student_Section exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Instructor TEACHES Section on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Instructor"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="TEACHES", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Id" */
    IF EXISTS (SELECT * FROM deleted,Instructor
      WHERE
        /* %JoinFKPK(deleted,Instructor," = "," AND") */
        deleted.Id = Instructor.Id AND
        NOT EXISTS (
          SELECT * FROM Section
          WHERE
            /* %JoinFKPK(Section,Instructor," = "," AND") */
            Section.Id = Instructor.Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Section because Instructor exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Course SECS Section on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Course"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="SECS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="CCode""CoName" */
    IF EXISTS (SELECT * FROM deleted,Course
      WHERE
        /* %JoinFKPK(deleted,Course," = "," AND") */
        deleted.CCode = Course.CCode AND
        deleted.CoName = Course.CoName AND
        NOT EXISTS (
          SELECT * FROM Section
          WHERE
            /* %JoinFKPK(Section,Course," = "," AND") */
            Section.CCode = Course.CCode AND
            Section.CoName = Course.CoName
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Section because Course exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Section ON Section FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Section */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insSecId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Section  Student_Section on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0003ff29", PARENT_OWNER="", PARENT_TABLE="Section"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="SecId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(SecId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Student_Section
      WHERE
        /*  %JoinFKPK(Student_Section,deleted," = "," AND") */
        Student_Section.SecId = deleted.SecId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Section because Student_Section exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Instructor TEACHES Section on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Instructor"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="TEACHES", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Instructor
        WHERE
          /* %JoinFKPK(inserted,Instructor) */
          inserted.Id = Instructor.Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Id IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Section because Instructor does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Course SECS Section on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Course"
    CHILD_OWNER="", CHILD_TABLE="Section"
    P2C_VERB_PHRASE="SECS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="CCode""CoName" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CCode) OR
    UPDATE(CoName)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Course
        WHERE
          /* %JoinFKPK(inserted,Course) */
          inserted.CCode = Course.CCode and
          inserted.CoName = Course.CoName
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CCode IS NULL AND
      inserted.CoName IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Section because Course does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Student ON Student FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Student */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Student  Student_Section on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00023834", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="SId" */
    IF EXISTS (
      SELECT * FROM deleted,Student_Section
      WHERE
        /*  %JoinFKPK(Student_Section,deleted," = "," AND") */
        Student_Section.SId = deleted.SId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Student because Student_Section exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Dept HAS Student on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Student"
    P2C_VERB_PHRASE="HAS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="DName""DCode" */
    IF EXISTS (SELECT * FROM deleted,Dept
      WHERE
        /* %JoinFKPK(deleted,Dept," = "," AND") */
        deleted.DName = Dept.DName AND
        deleted.DCode = Dept.DCode AND
        NOT EXISTS (
          SELECT * FROM Student
          WHERE
            /* %JoinFKPK(Student,Dept," = "," AND") */
            Student.DName = Dept.DName AND
            Student.DCode = Dept.DCode
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Student because Dept exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Student ON Student FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Student */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insSId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Student  Student_Section on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00029ecc", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="SId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(SId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Student_Section
      WHERE
        /*  %JoinFKPK(Student_Section,deleted," = "," AND") */
        Student_Section.SId = deleted.SId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Student because Student_Section exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Dept HAS Student on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dept"
    CHILD_OWNER="", CHILD_TABLE="Student"
    P2C_VERB_PHRASE="HAS", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="DName""DCode" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(DName) OR
    UPDATE(DCode)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Dept
        WHERE
          /* %JoinFKPK(inserted,Dept) */
          inserted.DName = Dept.DName and
          inserted.DCode = Dept.DCode
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.DName IS NULL AND
      inserted.DCode IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Student because Dept does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Student_Section ON Student_Section FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Student_Section */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Section  Student_Section on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000261d1", PARENT_OWNER="", PARENT_TABLE="Section"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="SecId" */
    IF EXISTS (SELECT * FROM deleted,Section
      WHERE
        /* %JoinFKPK(deleted,Section," = "," AND") */
        deleted.SecId = Section.SecId AND
        NOT EXISTS (
          SELECT * FROM Student_Section
          WHERE
            /* %JoinFKPK(Student_Section,Section," = "," AND") */
            Student_Section.SecId = Section.SecId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Student_Section because Section exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Student  Student_Section on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="SId" */
    IF EXISTS (SELECT * FROM deleted,Student
      WHERE
        /* %JoinFKPK(deleted,Student," = "," AND") */
        deleted.SId = Student.SId AND
        NOT EXISTS (
          SELECT * FROM Student_Section
          WHERE
            /* %JoinFKPK(Student_Section,Student," = "," AND") */
            Student_Section.SId = Student.SId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Student_Section because Student exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Student_Section ON Student_Section FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Student_Section */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insSId char(18), 
           @insSecId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Section  Student_Section on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002a39d", PARENT_OWNER="", PARENT_TABLE="Section"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="SecId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(SecId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Section
        WHERE
          /* %JoinFKPK(inserted,Section) */
          inserted.SecId = Section.SecId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Student_Section because Section does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Student  Student_Section on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Student_Section"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_35", FK_COLUMNS="SId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(SId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Student
        WHERE
          /* %JoinFKPK(inserted,Student) */
          inserted.SId = Student.SId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Student_Section because Student does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


