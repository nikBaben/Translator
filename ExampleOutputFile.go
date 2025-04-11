package main

import (
	"fmt"
	"sort"
)

type Student struct {
	Name  string
	Group string
	Grade float64
}

func compareStudents(a, b Student) bool {
	return a.Grade > b.Grade
}

func output(students []Student, index int) {
	fmt.Printf("%s %.2f %s\n", students[index].Name, students[index].Grade, students[index].Group)
}

func calculateStatistics(students []Student, showAboveAverage bool) {
	if len(students) == 0 {
		fmt.Println("Нет студентов для анализа.")
		return
	}

	sum := 0.0
	for _, student := range students {
		sum += student.Grade
	}

	average := sum / float64(len(students))
	fmt.Printf("\nСредняя оценка: %.2f\n", average)

	if showAboveAverage {
		fmt.Println("Студенты с оценками выше средней:")
		for i, student := range students {
			if student.Grade > average {
				output(students, i)
			}
		}
	} else {
		fmt.Println("Студенты с оценками ниже или равными средней:")
		for i, student := range students {
			if student.Grade <= average {
				output(students, i)
			}
		}
	}
}

func main() {
	var n int
	fmt.Print("Введите количество студентов: ")
	for {
		_, err := fmt.Scan(&n)
		if err == nil && n > 0 {
			break
		}
		fmt.Println("Ошибка! Введите корректное положительное число: ")
		fmt.Scanln()
	}

	students := make([]Student, n)

	for i := 0; i < n; i++ {
		fmt.Print("Введите имя, группу и оценку студента: ")
		fmt.Scan(&students[i].Name, &students[i].Group, &students[i].Grade)
	}

	sort.Slice(students, func(i, j int) bool {
		return compareStudents(students[i], students[j])
	})

	var showAboveAverage bool
	fmt.Print("\n(1 - Студенты с оценкой выше средней, 0 - Студенты с оценкой ниже или равной средней): ")
	fmt.Scan(&showAboveAverage)

	calculateStatistics(students, showAboveAverage)
}
