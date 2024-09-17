# DOSP
# cis6930fa24-assignment0
## Name: Priya Mittal & Rijul Bir Singh
### Assignment Description
Problem statement is to divide a range of numbers into smaller chunks and processes them in parallel using actors. 
The goal is to find numbers for which the sum of squares of consecutive k numbers is a perfect square. The first number of the answer sequence needs to be in the range: 1 to n.
The task is distributed among multiple workers, each responsible for a specific range of numbers- showcasing parallelism.

### How to install
#### Install Homebrew (for mac) <br>
⁠ ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh ```
<br>
#### Install ponyc <br>
``` brew install ponyc ```
<br>
#### Verify version <br>

``` ponyc --version ```

### How to Run
To compile your program, run
```⁠  ponyc ```
To run the program
``` ./lukas <n> <k> <br> ```
To find time of the program
``` time ./lukas <n> <k> ```

## Work Flow

**1. Main Actor:**
The main actor takes in the command line arguments, converts them to integers and creates the BOSS
**2. Boss Actor:**
The Boss actor assigns number of workers and divide the work among the worker actors. It then prints the answer. If there is no answer then it says ALL WORKERS COMPLETED
**3. Worker:**
The worker processes the assigned range to find k consecutive numbers whose sum of squares is a perfect square.
If the Worker finds the starting number of the first sequence then it sends the answer back to the BOSS and terminates the program. If no perfect square answer is found then 0 is returned to the BOSS actor.

⁠ 
## Functions
### main.py
**Boss Actor Functions:**

*run()*
Divides the range from 1 to n into smaller chunks.
Each chunk is assigned to a Worker actor.
It prints the start and end points for each worker’s range.

*result()*
Called by workers to report their findings.
It collects and prints the result (if any) and checks if all workers have completed their tasks.


**Worker Actor Functions:**

*_process():*
Processes the range of numbers and checks each one for the sequence condition.
If a number satisfies the condition, it is pushed into an array and sent back to the Boss.

*_is_perfect_square_sum():*
For each number i in the range, this function computes the sum of squares for the next k consecutive numbers.
It checks if this sum is a perfect square

*_sqrt():*
A custom square root function was implemented using Newton’s method.


This function formats the data in the required format by removing *''* and adding thorn seperator after the required fields.It then prints the data. 


## TEST CASES

rijul@Rijuls-MacBook-Air ponyF % time ./ponyF 3 2  
Total workers: 1
ANSWER: 3
All workers completed.
./ponyF 3 2  0.02s user 0.00s system 9% cpu 0.304 total


rijul@Rijuls-MacBook-Air ponyF % time ./ponyF 40 24
Total workers: 9
ANSWER: 9
All workers completed.
./ponyF 40 24  0.02s user 0.00s system 265% cpu 0.009 total


rijul@Rijuls-MacBook-Air ponyF % time ./ponyF 1 1  
Total workers: 1
ANSWER: 1
All workers completed.
./ponyF 1 1  0.04s user 0.00s system 334% cpu 0.013 total

rijul@Rijuls-MacBook-Air ponyF % time ./ponyF 100000000 20
Total workers: 20000001
zsh: killed     ./ponyF 100000000 20
./ponyF 100000000 20  73.02s user 9.87s system 419% cpu 19.762 total
