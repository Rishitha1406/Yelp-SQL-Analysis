-- Create Businesses table
CREATE TABLE Businesses (
    BusinessID VARCHAR(22),
    Name VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(100),
    State CHAR(2),
    PostalCode VARCHAR(9),
    Latitude DECIMAL(10, 7),
    Longitude DECIMAL(10, 7),
    AvgReviews DECIMAL(3, 2),
    NumReviews INT,
    IsOpen INT,
	CONSTRAINT AvgReviews CHECK (AvgReviews >= 0.0 AND AvgReviews <= 5.0),
    CONSTRAINT IsOpen CHECK (IsOpen = ANY (ARRAY[0, 1]))
);
DROP TABLE Users;

CREATE TABLE BusinessAttributes (
    BusinessID VARCHAR(22),
    AttributeName VARCHAR(255),
    AttributeValue VARCHAR(255),
    PRIMARY KEY (BusinessID, AttributeName)
);

-- Create BusinessCategories table
CREATE TABLE BusinessCategories (
    BusinessID VARCHAR(22),
    CategoryName VARCHAR(255)
);

-- Create BusinessHours table
CREATE TABLE BusinessHours (
    BusinessID VARCHAR(22),
    DayOfWeek VARCHAR(20),
    OpeningTime TIME WITHOUT TIME ZONE,
    ClosingTime TIME WITHOUT TIME ZONE
);

-- Create Users table
CREATE TABLE Users (
    UserID VARCHAR(22) PRIMARY KEY,
    Name VARCHAR(255),
    NumReviews INT,
    JoinDateTime TIMESTAMP WITHOUT TIME ZONE,
    UsefulVotesSent INT,
    FunnyVotesSent INT,
    CoolVotesSent INT,
    NumFans INT,
    AvgRating DECIMAL(3, 2),
    NumHotCompliments INT,
    NumMoreCompliments INT,
    NumProfileCompliments INT,
    NumCuteCompliments INT,
    NumListCompliments INT,
    NumNoteCompliments INT,
    NumPlainCompliments INT,
    NumCoolCompliments INT,
    NumFunnyCompliments INT,
    NumWriterCompliments INT,
    NumPhotoCompliments INT,
	CONSTRAINT AvgRating CHECK (AvgRating >= 0.0 AND AvgRating <= 5.0)
);

-- Create UserEliteYears table
CREATE TABLE UserEliteYears (
    UserID VARCHAR(22),
    Year INT,
    PRIMARY KEY (UserID, Year)
);

-- Create Tips table
CREATE TABLE Tips (
    UserID VARCHAR(22),
    BusinessID VARCHAR(22),
    TipText TEXT,
    TipDateTime TIMESTAMP WITHOUT TIME ZONE,
    NumCompliments INT
);

-- Create Reviews table
CREATE TABLE Reviews (
    ReviewID VARCHAR(22),
    UserID VARCHAR(22),
    BusinessID VARCHAR(22),
    UserRating DECIMAL(3, 1),
    UsefulVotes INT,
    FunnyVotes INT,
    CoolVotes INT,
    ReviewText TEXT,
    ReviewDateTime TIMESTAMP WITHOUT TIME ZONE,
	CONSTRAINT UserRating CHECK (UserRating >= 0.0 AND UserRating <= 5.0)
);

DROP TABLE reviews;