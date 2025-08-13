// app.component.ts
import { Component, OnInit } from '@angular/core';

// ✅ Import required Angular modules and directives
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// ✅ Import standalone directives and pipes
import { NgIf, NgFor, DecimalPipe } from '@angular/common';

import { Expense } from './expense.model';
import { ExpenseService } from './expense.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  // ✅ Add imports here (required for standalone components)
  imports: [
    CommonModule,    // Provides *ngIf, *ngFor, | number, etc.
    FormsModule,     // Provides [(ngModel)], #ngForm
    NgIf,            // Optional: if you want to list it explicitly
    NgFor,
    DecimalPipe
  ],
  standalone: true  // This is auto-set in Angular 20
})
export class AppComponent implements OnInit {
  expenses: Expense[] = [];
  newExpense: Expense = { description: '', amount: 0, date: '' };
  editingId: number | null = null;

  constructor(private expenseService: ExpenseService) {}

  ngOnInit(): void {
    this.loadExpenses();
  }

  loadExpenses() {
    this.expenseService.getAll().subscribe({
      next: (data) => {
        this.expenses = data;
      },
      error: (err) => {
        console.error('Failed to load expenses', err);
      }
    });
  }

  addExpense() {
    if (!this.isValidExpense()) return;

    this.expenseService.create(this.newExpense).subscribe({
      next: () => {
        this.resetForm();
        this.loadExpenses();
      },
      error: (err) => {
        console.error('Failed to add expense', err);
      }
    });
  }

  startEdit(expense: Expense) {
    this.editingId = expense.id!;
    this.newExpense = { ...expense };
  }

  updateExpense() {
    if (!this.editingId || !this.isValidExpense()) return;

    this.expenseService.update(this.editingId, this.newExpense).subscribe({
      next: () => {
        this.resetForm();
        this.loadExpenses();
      },
      error: (err) => {
        console.error('Failed to update expense', err);
      }
    });
  }

  deleteExpense(id: number) {
    if (confirm('Are you sure you want to delete this expense?')) {
      this.expenseService.delete(id).subscribe({
        next: () => {
          this.loadExpenses();
        },
        error: (err) => {
          console.error('Failed to delete expense', err);
        }
      });
    }
  }

  onSubmit() {
    if (this.editingId) {
      this.updateExpense();
    } else {
      this.addExpense();
    }
  }

  onCancel() {
    this.resetForm();
  }

  private resetForm() {
    this.newExpense = { description: '', amount: 0, date: '' };
    this.editingId = null;
  }

  // ✅ Make this method public so it can be used in template
  isValidExpense(): boolean {
    return !!this.newExpense.description &&
           this.newExpense.amount > 0 &&
           !!this.newExpense.date;
  }
}