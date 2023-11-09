import 'dart:io';
import 'dart:math';

void main() {
  int maxNumber = setDifficulty();
  int randomNumber = Random().nextInt(maxNumber) + 1;
  int maxAttempts = 10;
  int attempts = 0;
  List<int> highScores = [];

  print('Guess the number between 1 and $maxNumber');
  print('You have $maxAttempts attempts. Good luck!');

  while (attempts < maxAttempts) {
    stdout.write('Enter your guess: ');
    String? input = stdin.readLineSync();
    int guess = int.tryParse(input ?? '') ?? 0;

    if (guess == randomNumber) {
      print('Congratulations! You guessed the right number.');
      highScores.add(maxAttempts - attempts);
      break;
    } else if (guess < randomNumber) {
      print('Too low!');
    } else {
      print('Too high!');
    }
    attempts++;
    print('Attempts left: ${maxAttempts - attempts}');
  }

  if (attempts == maxAttempts) {
    print('Game over! The number was $randomNumber.');
  }

  printHighScores(highScores);
}

void printHighScores(List<int> scores) {
  print('High Scores:');
  scores.sort((a, b) => b.compareTo(a));
  for (var score in scores) {
    print(score);
  }
}

int setDifficulty() {
  print('Select difficulty level (1-3):');
  print('1. Easy (1-50)');
  print('2. Medium (1-100)');
  print('3. Hard (1-200)');
  stdout.write('Enter the difficulty level: ');
  String? input = stdin.readLineSync();
  int difficulty = int.tryParse(input ?? '') ?? 1;

  switch (difficulty) {
    case 1:
      return 50;
    case 2:
      return 100;
    case 3:
      return 200;
    default:
      print('Invalid difficulty level, setting to Easy.');
      return 50;
  }
}
