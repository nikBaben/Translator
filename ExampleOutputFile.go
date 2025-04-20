package main

import (
	"fmt"
	"sort"
)

type Student struct {
	name  string
	group string
	grade float64
}

func compareStudents(a Student, b Student) bool {
	return a.grade > b.grade

}

func output(students []Student, index int) {
	fmt.Println(students[index].name, " ", students[index].grade, " ", students[index].group)

}

func calculateStatistics(students []Student, count int, showAboveAverage bool) {
	if count == 0 {
		fmt.Println("Нет студентов для анализа.")

		return

	}
	var sum float64 = 0.000000
	for i := 0; i < count; i++ {
		sum += students[i].grade

	}
	var average float64
	average = sum / float64(count)
	fmt.Println("\nСредняя оценка: ", average)

	if showAboveAverage {
		fmt.Println("Студенты с оценками выше средней:")

		for i := 0; i < count; i++ {
			if students[i].grade > average {
				output(students, i)

			}

		}

	}
	if !showAboveAverage {
		fmt.Println("Студенты с оценками ниже или равными средней:")

		for i := 0; i < count; i++ {
			if students[i].grade <= average {
				output(students, i)

			}

		}

	}

}

func main() {

	var n int
	fmt.Println("Введите количество студентов: ")

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
		fmt.Println("Введите имя, группу и оценку студента:")

		fmt.Scan(&students[i].name, &students[i].group, &students[i].grade)

	}
	sort.Slice(students, func(i, j int) bool {

		return compareStudents(students[i], students[j])
	})
	var showAboveAverage bool
	fmt.Println("\n(1 - Студенты с оценкой выше средней, 0 - Студенты с оценкой ниже или равной средней): ")

	fmt.Scan(&showAboveAverage)

	calculateStatistics(students, n, showAboveAverage)

}
