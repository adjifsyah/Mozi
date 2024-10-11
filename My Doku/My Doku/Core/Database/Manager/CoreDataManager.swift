//
//  CoreDataManager.swift
//  My Doku
//
//  Created by Adji Firmansyah on 28/08/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "My_Doku")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Category Management
    func createCategory(name: String, limit: Double, parentCategory: Category?) -> Category? {
        let isNotContain = !fetchCategories().contains(where: { $0.name?.contains(name) ?? false })
        guard isNotContain else {
            if let category = fetchCategories().first(where: { $0.name?.lowercased().contains(name.lowercased()) ?? false }) {
                deleteCategory(category: category)
            }
            
            return nil
        }
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category.name = name
        category.limit = limit
        category.parentCategory = parentCategory
        
        do {
            try context.save()
            return category
        } catch {
            print("Failed to save category: \(error)")
            return nil
        }
    }
    
    func fetchCategories() -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
    func updateCategory(category: Category, name: String?, limit: Double?) {
        if let name = name {
            category.name = name
        }
        if let limit = limit {
            category.limit = limit
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to update category: \(error)")
        }
    }
    
    func deleteCategory(category: Category) {
        context.delete(category)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
    
    // MARK: - Expense Management
    func createExpense(amount: Double, date: Date, notes: String?, category: Category?, income: Income?) -> Expense? {
        let isNotContain = !fetchExpenses().contains(where: { $0.amount == amount })
        guard isNotContain else {
            if let income = fetchExpenses().first(where: { $0.amount == amount }) {
                deleteExpense(expense: income)
            }
            return nil
        }
        
        
        let expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as! Expense
        expense.amount = amount
        expense.date = date
        expense.notes = notes
        expense.category = category
        expense.income = income
        
        do {
            try context.save()
            return expense
        } catch {
            print("Failed to save expense: \(error)")
            return nil
        }
    }
    
    func fetchExpenses() -> [Expense] {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch expenses: \(error)")
            return []
        }
    }
    
    func updateExpense(expense: Expense, amount: Double?, date: Date?, notes: String?) {
        if let amount = amount {
            expense.amount = amount
        }
        if let date = date {
            expense.date = date
        }
        if let notes = notes {
            expense.notes = notes
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to update expense: \(error)")
        }
    }
    
    func deleteExpense(expense: Expense) {
        context.delete(expense)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete expense: \(error)")
        }
    }
    
    // MARK: - Income Management
    func createIncome(amount: Double, type: String, date: Date, paymentMethod: Payment?) -> Income? {
        let isNotContain = !fetchIncomes().contains(where: { $0.amount == amount })
        guard isNotContain else {
            if let income = fetchIncomes().first(where: { $0.amount == amount }) {
                deleteIncome(income: income)
            }
            return nil
        }
        
        let income = NSEntityDescription.insertNewObject(forEntityName: "Income", into: context) as! Income
        income.amount = amount
        income.type = type
        income.date = date
        income.payment = paymentMethod
        
        do {
            try context.save()
            return income
        } catch {
            print("Failed to save income: \(error)")
            return nil
        }
    }
    
    func fetchIncomes() -> [Income] {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch incomes: \(error)")
            return []
        }
    }
    
    func updateIncome(income: Income, amount: Double?, type: String?, date: Date?) {
        if let amount = amount {
            income.amount = amount
        }
        if let type = type {
            income.type = type
        }
        if let date = date {
            income.date = date
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to update income: \(error)")
        }
    }
    
    func deleteIncome(income: Income) {
        context.delete(income)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete income: \(error)")
        }
    }
    
    // MARK: - Payment Management
    func fetchPayment() -> [Payment] {
        let fetchRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch incomes: \(error)")
            return []
        }
    }
    
    func createPayment(name: String) -> Payment? {
        let isNotContain = !fetchPayment().contains(where: { $0.name?.contains(name) ?? false })
        guard isNotContain else {
            if let payment = fetchPayment().first(where: { $0.name?.lowercased().contains(name.lowercased()) ?? false }) {
                deletePayment(payment: payment)
            }
            return nil
        }
        guard let payment = NSEntityDescription.insertNewObject(forEntityName: "Payment", into: context) as? Payment else { return nil }
        payment.name = name
        
        do {
            try context.save()
            return payment
        } catch {
            print("Failed to save payment: \(error)")
            return nil
        }
    }
    
    
    func deletePayment(payment: Payment) {
        context.delete(payment)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete payment: \(error)")
        }
    }
}

