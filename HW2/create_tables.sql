create table books (
    bid integer,
    bname VARCHAR(50),
    author VARCHAR(50),
    year integer,
    price integer,
    primary key (bid)
);

create table customers (
    cid integer,
    cname VARCHAR(50),
    zipcode VARCHAR(5),
    primary key (cid)
);

create table orders (
    cid integer,
    bid integer,
    quantity integer,
    primary key (cid, bid),
    foreign key (cid) references customers,
    foreign key (bid) references books
);

create table passengers (
    pid integer,
    pname VARCHAR(50),
    age integer,
    city VARCHAR(50),
    primary key (pid)
);

create table flights (
    fid integer,
    "from" VARCHAR(50),
    "to" VARCHAR(50),
    miles integer,
    aircraft VARCHAR(50),
    primary key (fid)
);

create table tickets (
    pid integer,
    fid integer,
    price integer,
    primary key (pid, fid),
    foreign key (pid) references passengers,
    foreign key (fid) references flights
);