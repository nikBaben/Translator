#include <iostream>
#include <string>

using namespace std;

struct Student {
    string name;
    string group;
    float grade;
};

bool compareStudents(const Student& a, const Student& b) {
    return a.grade > b.grade;
}

void output(const Student* students, int index) {
    cout << students[index].name << " " << students[index].grade << " " << students[index].group << endl;
}

void calculateStatistics(const Student* students, int count, bool showAboveAverage) {
    if (count == 0) {
        cout << "Нет студентов для анализа." << endl;
        return;
    }

    float sum = 0.0;
    for (int i = 0; i < count; i++) {
        sum += students[i].grade;
    }

    float average;
    average = sum / float(count);
    cout << "\nСредняя оценка: " << average << endl;

    if (showAboveAverage) {
        cout << "Студенты с оценками выше средней:" << endl;
        for (int i = 0; i < count; i++) {
            if (students[i].grade > average) {
                output(students, i);
            }
        }
    } 
    if (!showAboveAverage) {
        cout << "Студенты с оценками ниже или равными средней:" << endl;
        for (int i = 0; i < count; i++) {
            if (students[i].grade <= average) {
                output(students, i);
            }
        }
    }
}

int main() {
    int n;

    cout << "Введите количество студентов: ";
    while (!(cin >> n) || n <= 0) {
        cout << "Ошибка! Введите корректное положительное число: ";
        cin.clear();
        while (cin.get() != '\n');
    }

    Student* students = new Student[n];

    for (int i = 0; i < n; i++) {
        cout << "Введите имя, группу и оценку студента:";
        cin >> students[i].name >> students[i].group >> students[i].grade;
    }

    sort(students, students + n, compareStudents);

    bool showAboveAverage;
    cout << "\n(1 - Студенты с оценкой выше средней, 0 - Студенты с оценкой ниже или равной средней): ";
    cin >> showAboveAverage;

    calculateStatistics(students, n, showAboveAverage);

    delete[] students;
    return 0;
}
