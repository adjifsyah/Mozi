//
//  HomeScreen.swift
//  My Doku
//
//  Created by Adji Firmansyah on 28/08/24.
//

import SwiftUI
import BottomSheet

struct HomeScreen: View {
    let manager = CoreDataManager.shared
    
    @State var amount: String = ""
    @State var selectedPayment: Payment = Payment()
    @State var date: Date = Date.now
    @State var isPayment: Bool = false
    @State var isAdd: Bool = false
    @State var isAddCategory: Bool = false
    @State var isAlert: Bool = false
    @State var msgAlert: String = ""
    @State var listCategory: [CategoryTransaction] = [.expense, .income]
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        Text("Income")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(manager.fetchIncomes()) { income in
                                    VStack(alignment: .leading, spacing: 20) {
                                        HStack {
                                            Text(income.payment?.name ?? "")
                                            Spacer()
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Saldo")
                                                .font(.system(size: 12))
                                            Text("\(income.amount.currencyFormatting)")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                        }
                                        Spacer()
                                        
                                    }
                                    .frame(width: proxy.frame(in: .local).width / 2.6, height: proxy.frame(in: .local).width / 2)
                                    .background(.white)
                                    .cornerRadius(4)
                                    .clipped()
                                    .shadow(radius: 2)
                                    .padding(8)
                                    
                                }
                            }
                        }
                        .padding(-8)
                        .safeAreaInset(edge: .leading) {
                            Spacer().frame(width: 20)
                        }
                        
                        Text("Payment")
                        ForEach(manager.fetchPayment()) { expense in
                            Text("\(expense.name ?? "")")
                        }
                        
                        
                        //                    Text("Category")
                        //                    ForEach(manager.fetchCategories()) { expense in
                        //                        Text("\(expense.name ?? "")")
                        //                    }
                        Divider()
                        Text("Expenses")
                        ForEach(manager.fetchExpenses()) { expense in
                            Text("\(expense.amount.currencyFormatting)")
                                .onAppear {
                                    selectedPayment = manager.fetchPayment().first!
                                }
                        }
                    }
                }
                .onAppear {
//                    let amount: Double = 125200
                    //                let payment = manager.createPayment(name: "CASH")
                    //                let income = manager.createIncome(amount: amount, type: "Gajian", date: .now, paymentMethod: payment)
                    //                manager.createExpense(amount: amount, date: .now, notes: "ini catetan baru", category: manager.fetchCategories().first, income: income)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            isAdd.toggle()
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $isAdd) {
                VStack {
                    HStack {
                        Picker("Selectd", selection: $selectedPayment) {
                            ForEach(listCategory, id: \.rawValue) { category in
                                Text(category.rawValue)
                                    .background(.cyan)
                                    .onAppear {
                                        if let firstPayment = manager.fetchPayment().first {
                                            selectedPayment = firstPayment
                                        }
                                    }
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    Button {
                        isAddCategory.toggle()
                    } label: {
                        Text("Category")
                    }
                    .sheet(isPresented: $isAddCategory) {
                        Text("All Category")
                            .presentationDetents([.fraction(0.5)])
                    } 
                    

                    Spacer()
                }
                .presentationDetents([.fraction(0.5)])
            }
        }
    }
}

#Preview {
    HomeScreen()
}

extension Double {
    var currencyFormatting: String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let amountInteger = Int(self)
        
        number = NSNumber(value: (amountInteger))
        guard number != 0 as NSNumber else {
            return "Rp 0"
        }
        if let amount = formatter.string(from: number) {
            return "Rp " + amount
        } else {
            return "Rp 0"
        }
    }
}

enum CategoryTransaction: String {
    case income = "Income"
    case expense = "Expense"
}
