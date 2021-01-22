DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS productinventory;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS orderproduct;
DROP TABLE IF EXISTS incart;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS ordersummary;
DROP TABLE IF EXISTS paymentmethod;
DROP TABLE IF EXISTS customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Action');
INSERT INTO category(categoryName) VALUES ('RPG');
INSERT INTO category(categoryName) VALUES ('Indie');
INSERT INTO category(categoryName) VALUES ('Sports');
INSERT INTO category(categoryName) VALUES ('Simulation');
INSERT INTO category(categoryName) VALUES ('MMO');
INSERT INTO category(categoryName) VALUES ('Strategy');
INSERT INTO category(categoryName) VALUES ('Racing');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Counter-Strike: Global Offensive', 1, 'CS:GO expands upon the team-based action gameplay that it pioneered when it was launched 19 years ago.',18.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Red Dead Redemption 2',1,'Arthur Morgan and the Van der Linde gang are outlaws on the run. With federeal agents and the best bounty bunters in the nation massing on their heels.',78.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Hades',2,'Hades is a god-like rogue-like dungeon crawler that combines the best aspects of Supergiants critically acclaimed titles.',27.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Monster Hunter: World',2,'Welcome to a new world! Take on the role of a hinter and slay ferocious monsters in a living breathing ecosystem.',38.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Crusader Kings III',2,'Paradox Development Studio brings you the sequel to the one of the most popular strategy games ever made.',55.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('The Elder Scrolls V: Skyrim',2,'SKYRIM',48.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('FIFA 21',4,'Play FIFA 21, Get David Beckham.',78.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Baldurs Gate 3',2,'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal.',78.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('American Truck Simulator',5,'Experience legendary trucks and deliver various vargoes across sunny California, sandy Nevada and the Grand Canyon State of Arizona',24.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('The Elder Scrolls Online',6,'Elder Scrolls MMO Adventure',23.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Stardew Valley',3,'Indie Farming Game',15.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Among Us',3,'Indie Mulitplayer Mystery Game',4.69);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('F1 2020',4,'Formula 1 Racing Game',67.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('The Witcher 3',2,'RPG Fantasy Game',54.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sid Meiers Civilization V',7,'A strategy historical game. Ramons favourite.',31.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('The Sims 4',5,'A slice of life simulation game',38.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Sea of Theives',6,'A pirating, seafaring simulation game',48.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Age of Empires II',7,'A historical live action battle game',20.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Total War: Rome II',7,'A live action historical battle game',70.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Squad',7,'A modern wartime strategy game',58.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('DiRT Rally',8,'A racing simulation physics-based game',27.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Dead by Daylight',1,'An intense horror action game',20.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Hell Let Loose',1,'A historical action shooter game',32.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('DayZ',6,'A survival zombie multiplayer game',58.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fall Guys: Ultimate Knockout',6,'A silly massive multiplayer challenge game',21.79);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('STAR WARS: The Old Republic',6,'A StarWars based MMO game',28.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Assetto Corsa',8,'A realistic pretty racing game',21.79);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Cyberpunk 2077',2,'A futuristic role play game',78.99);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Project Wingman',1,'A flight simulation dogfight action game',27.99);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 18);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 19);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 10);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 22);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 21.35);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 25);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 30);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 40);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 97);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 31);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/1_a.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;