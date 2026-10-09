#!/bin/bash

MYSQL="mysql -h127.0.0.1 -P3306 -uroot -proot"

echo "========================================"
echo " Course Table SQL Assignment"
echo "========================================"

# Check whether the student's SQL file exists
if [ ! -f "student_solution.sql" ]; then
    echo "FAIL: student_solution.sql file not found."
    exit 1
fi

echo "Creating fresh CollegeDB database..."

# Create fresh database
$MYSQL -e "DROP DATABASE IF EXISTS CollegeDB;"
$MYSQL -e "CREATE DATABASE CollegeDB;"

echo "Executing student_solution.sql..."

# Execute student's SQL
if ! $MYSQL CollegeDB < student_solution.sql; then
    echo "FAIL: Error while executing student_solution.sql"
    exit 1
fi

echo ""
echo "Checking Course table..."
echo ""

MARKS=0

# ----------------------------------------
# Test Case 1: Course table exists
# ----------------------------------------

TABLE=$($MYSQL -N -s CollegeDB -e "
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course';
")

if [ "$TABLE" = "Course" ]; then
    echo "PASS: Course table exists."
    MARKS=$((MARKS+2))
else
    echo "FAIL: Course table was not created."
    exit 1
fi

# ----------------------------------------
# Test Case 2: CourseID exists
# ----------------------------------------

COURSEID=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course'
AND COLUMN_NAME='CourseID';
")

if [ "$COURSEID" -eq 1 ]; then
    echo "PASS: CourseID column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: CourseID column missing."
fi

# ----------------------------------------
# Test Case 3: CourseName exists
# ----------------------------------------

COURSENAME=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course'
AND COLUMN_NAME='CourseName';
")

if [ "$COURSENAME" -eq 1 ]; then
    echo "PASS: CourseName column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: CourseName column missing."
fi

# ----------------------------------------
# Test Case 4: Credits exists
# ----------------------------------------

CREDITS=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course'
AND COLUMN_NAME='Credits';
")

if [ "$CREDITS" -eq 1 ]; then
    echo "PASS: Credits column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Credits column missing."
fi

# ----------------------------------------
# Test Case 5: DepartmentID exists
# ----------------------------------------

DEPARTMENTID=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course'
AND COLUMN_NAME='DepartmentID';
")

if [ "$DEPARTMENTID" -eq 1 ]; then
    echo "PASS: DepartmentID column exists."
    MARKS=$((MARKS+1))
else
    echo "FAIL: DepartmentID column missing."
fi

# ----------------------------------------
# Test Case 6: At least 3 records
# ----------------------------------------

RECORDS=$($MYSQL -N -s CollegeDB -e "
SELECT COUNT(*)
FROM Course;
")

if [ "$RECORDS" -ge 3 ]; then
    echo "PASS: At least 3 records inserted."
    MARKS=$((MARKS+2))
else
    echo "FAIL: At least 3 records are required."
fi

# ----------------------------------------
# Test Case 7: CourseID Primary Key
# ----------------------------------------

PK=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course'
AND CONSTRAINT_NAME='PRIMARY'
AND COLUMN_NAME='CourseID';
")

if [ "$PK" -eq 1 ]; then
    echo "PASS: CourseID is Primary Key."
    MARKS=$((MARKS+1))
else
    echo "FAIL: CourseID is not Primary Key."
fi

# ----------------------------------------
# Test Case 8: Display Course structure
# ----------------------------------------

COLUMN_COUNT=$($MYSQL -N -s -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Course';
")

if [ "$COLUMN_COUNT" -eq 4 ]; then
    echo "PASS: Course table structure is correct."
    MARKS=$((MARKS+1))
else
    echo "FAIL: Course table structure is incorrect."
fi

echo ""
echo "========================================"
echo "Course Table Structure"
echo "========================================"

$MYSQL CollegeDB -e "DESCRIBE Course;"

echo ""
echo "========================================"
echo "Course Table Records"
echo "========================================"

$MYSQL CollegeDB -e "SELECT * FROM Course;"

echo ""
echo "========================================"
echo "Total Marks: $MARKS / 10"
echo "========================================"

if [ "$MARKS" -eq 10 ]; then
    echo "SUCCESS: All test cases passed."
    exit 0
else
    echo "Some test cases failed."
    exit 1
fi
