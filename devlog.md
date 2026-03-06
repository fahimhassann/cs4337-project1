## 2026-03-06

Thoughts so far:
- This project is a prefix-notation calculator written in Racket.
- It needs to support interactive mode and batch mode.
- It also needs to keep a history of previous successful results.
- I will need to handle invalid expressions and print errors correctly.

Plan overall:
- Set up the repository and files first.
- Build the calculator in small parts.
- Start with a basic Racket file and test that it runs.
- Then implement parsing and evaluation.
- Then add history support.
- Then add batch mode and test everything.

## 2026-03-06

Thoughts so far:
- I finished the initial setup and verified that Racket works from the terminal.
- The next step is to create the main program file and make sure I can run a simple Racket program before building the calculator logic.

Plan for this session:
- Create main.rkt.
- Test that the program runs correctly with racket main.rkt.
- After that, start building the interactive input loop.

## 2026-03-06

Thoughts so far:
- I moved from the simple input loop to the actual evaluator structure.
- The program can now parse numeric values, ignore whitespace, detect invalid input, and reject extra text after a valid expression.

Plan for this session:
- Extend eval-expr so it can evaluate operators in prefix notation.
- Add support for +, *, /, unary -, and history references using $n.

## 2025-03-06 

Plan for this session:
- Add support for the binary operators +, *, and /.
- Add support for the unary negation operator -.
- Implement history references using $n so previous results could be reused.
- Ensure errors were handled properly, such as division by zero or invalid expressions.
- Test the calculator with several valid and invalid inputs.
## 2026-03-06 (End of Session)

Session reflection:
In this session I implemented the core functionality of the prefix calculator. The program can now evaluate prefix expressions, handle operators (+, *, /, and unary -), and maintain a history of results using $n references. I also tested several valid and invalid expressions to verify the evaluator works correctly.

Next session plans:
Tomorrow I will implement batch mode support, create the README file for submission, and perform additional testing to ensure the program fully meets the project requirements.