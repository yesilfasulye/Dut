//
//  PopoverView.swift
//  Dut
//
//  Created by Burak Kaya on 7.10.2022.
//

import SwiftUI
import LaunchAtLogin

struct PopoverView: View {
    
    @AppStorage("displayMode") var displayMode = DisplayMode.auto
   
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest( sortDescriptors: [ SortDescriptor(\.date, order: .reverse) ]) var tasks: FetchedResults<Task>
    @FetchRequest( sortDescriptors: [ SortDescriptor(\.date, order: .forward) ]) var notes: FetchedResults<Notes>
    
    @State private var userNote: String = ""
    @State private var taskTitle: String = ""
    @State private var onHover:Int = -1
    @State private var tabIndicatorPos: CGFloat = 0
    @State private var confettiCounter: Int = 0
    @State private var activeNoteIndex: Int = 0
    
    @State private var removeCompleted: Bool = false
    @State private var disableDeleteAllButton: Bool = false
    @State private var showNotesOnly: Bool = false
    @State private var showAboutSection: Bool = false
    
    private enum Field: Hashable {
        case taskField, noteField
    }
    
    @FocusState private var focusField: Field?
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable
    
    var body: some View {
        
        ZStack {
            
            // Background Color
            Color("BackgroundColor").scaleEffect(1.5)
            
            if showAboutSection {
                
                ZStack {
                    
                    Color("BackgroundColor").scaleEffect(1.5)
                    
                    VStack {
                        
                        HStack {
                            Button(action: {
                                showAboutSection = false
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                            })
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .padding(8)
                        .padding(.bottom, 16)
                        
                        ZStack {
                            Image("appLogo")
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .background(Color("InputBgColor"))
                                .cornerRadius(24)
                                .onTapGesture(){confettiCounter += 1}
                            ConfettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        }
                        
                        Text("Dut")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color("TextColor"))
                            .padding(.top, 8)
                            .padding(.bottom, 0)
                        
                        Text("1.0.0")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom, 30)
                            .opacity(0.5)
                        
                        Text("© 2022 Burak Kaya")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("TextColor"))
                            .opacity(0.5)
                            .padding(1)
                        
                        
                        Link("github.com/yesilfasulye", destination: URL(string: "https://github.com/yesilfasulye")!)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("AccentColor"))
                            .padding(.bottom, 20)
                            .opacity(0.5)
                        
                    }
                    .background(Color("ContentBgColor"))
                    .cornerRadius(12)
                    .padding(50)
                    
                }
                
            }
            else {
                VStack(alignment: .leading, spacing: 0){
                    
                    // TABS
                    HStack {
                        
                        VStack (alignment: .leading) {
                            
                            HStack (spacing: 0) {
                                Button(action: {
                                    showNotesOnly = false
                                    tabIndicatorPos = 0
                                }, label: {
                                    Text("Tasks")
                                        .font(.system(size: 16, weight: showNotesOnly ? .regular : .bold))
                                        .foregroundColor(Color("TextColor"))
                                        .opacity(showNotesOnly ? 0.5 : 1)
                                        .frame(width: 80, height: 48)
                                        .contentShape(Rectangle())
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    showNotesOnly = true
                                    tabIndicatorPos = 80
                                }, label: {
                                    
                                    Text("Notes")
                                        .font(.system(size: 16, weight: showNotesOnly ? .bold : .regular))
                                        .foregroundColor(Color("TextColor"))
                                        .opacity(showNotesOnly ? 1 : 0.5)
                                        .frame(width: 80, height: 48)
                                        .contentShape(Rectangle())
                                    
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            
                        }
                        
                        Spacer()
                        
                        Menu {
                            
                            Group {
                                Button(action: {
                                    deleteCheckedTasks()
                                }, label: {
                                    Text("Delete Checked Tasks")
                                }).disabled(tasks.count > 0 ? false : true)
                                
                                Button(action: {
                                    deleteAllTasks()
                                }, label: {
                                    Text("Delete All Tasks")
                                }).disabled(tasks.count > 0 ? false : true)
                                
                                Button(action: {
                                    deleteAllNotes()
                                }, label: {
                                    Text("Delete All Notes")
                                }).disabled(notes.count > 0 ? false : true)
                            }
                            
                            Divider()
                            
                            Group {
                                Toggle("Auto-Delete Checked Task", isOn: $removeCompleted)
                                    .onChange(of: removeCompleted) { value in
                                        for task in tasks {
                                            if task.isDone && removeCompleted {
                                                withAnimation(.spring()){
                                                    deleteTask(t: task)
                                                }
                                            }
                                        }
                                    }
                                
                                Toggle("Launch at Login", isOn: $launchAtLogin.isEnabled)
                            }
                            
                            Divider()
                            
                            Group {
                                
                                Picker("Display Mode", selection: $displayMode) {
                                    Text("Light").tag(DisplayMode.light)
                                    Text("Dark").tag(DisplayMode.dark)
                                    Text("System Default").tag(DisplayMode.auto)
                                }
                                
                                Button(action: {
                                    showAboutSection = true
                                }, label: {
                                    Text("About")
                                })
                            }
                            
                            Divider()
                            
                            Button(action: {
                                NSApplication.shared.terminate(nil)
                            }, label: {
                                Text("Quit")
                            })
                            
                        } label: {
                            Image(systemName: "ellipsis").foregroundColor(Color("TextColor"))
                        }
                        .menuIndicator(.hidden)
                        .fixedSize()
                    }
                    .padding([.trailing])
                    .padding(.top, 8)
                    
                    // DIVIDER
                    ZStack (alignment: .leading) {
                        
                        Divider()
                        
                        Rectangle()
                            .fill(Color("AccentColor"))
                            .frame(width: 80, height: 1)
                            .padding(.leading, tabIndicatorPos)
                            .animation(.easeInOut(duration: 0.2), value: tabIndicatorPos)
                        
                    }
                    
                    // TAB CONTENT
                    VStack(alignment: .leading){
                        
                        // NOTES
                        if showNotesOnly {
                            
                            VStack (spacing: 0) {
                                
                                ZStack {
                                    
                                    if userNote == "" {
                                        VStack {
                                            Image(systemName: "note.text")
                                                .font(.system(size: 48.0, weight: .light))
                                                .padding(.bottom, 5)
                                                .foregroundColor(Color("TextColor"))
                                                .opacity(0.1)
                                            Text("Any notes?")
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color("TextColor"))
                                                .opacity(0.2)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 360)
                                        .padding()
                                    }
                                    
                                    TextEditor(text: $userNote)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color("TextColor"))
                                        .padding([.vertical, .horizontal])
                                        .background(.clear)
                                        .lineSpacing(4)
                                        .focused($focusField, equals: .noteField)
                                        .onChange(of: userNote, perform: { value in
                                            notes[activeNoteIndex].content = userNote
                                            do {
                                                try viewContext.save()
                                            } catch {
                                                let nsError = error as NSError
                                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                            }
                                        })
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                self.focusField = .noteField
                                            }
                                        }
                                }
                                
                                HStack {
                                    
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(Array(notes.enumerated()), id:\.element) { index, note in
                                                Group{
                                                    Text("􁉀")
                                                        .font(.system(size: 14))
                                                        .foregroundColor( index == activeNoteIndex ? Color("AccentColor") : Color("TextColor"))
                                                        .frame(width: 32, height: 32)
                                                }
                                                .background(self.onHover == notes.firstIndex(of: note)! ? Color("HoverColor") : Color("ContentBgColor"))
                                                .onHover { hover in
                                                    if hover && notes.count > 0 {
                                                        self.onHover = notes.firstIndex(of: note) ?? -1
                                                    } else {
                                                        self.onHover = -1
                                                    }
                                                }
                                                .onTapGesture {
                                                    activeNoteIndex = index
                                                    userNote = note.wrappedContent
                                                }
                                                .contextMenu {
                                                    
                                                    Button(action: {
                                                        clearNote(n: note)
                                                        userNote = notes[activeNoteIndex].content ?? ""
                                                    }, label: {
                                                        Text("Clear")
                                                    })
                                                    
                                                    Button(action: {
                                                        deleteNote(n: note)
                                                        if index == 0{
                                                            activeNoteIndex = 0
                                                        } else {
                                                            activeNoteIndex = index - 1
                                                        }
                                                        userNote = notes[activeNoteIndex].wrappedContent
                                                    }, label: {
                                                        Text("Delete")
                                                    })
                                                    .disabled(notes.count == 1 ? true : false)
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                
                                            }
                                        }
                                    }
                                    .padding(0)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        addNewNote()
                                        userNote = notes[notes.count - 1].content ?? ""
                                        activeNoteIndex = notes.count - 1
                                        
                                    }, label: {
                                        Text("􀅼")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 30, height: 30)
                                            .background(Color("AccentColor"))
                                            .cornerRadius(8)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    
                                }
                                .padding(12)
                                .background(Color("InputBgColor"))
                                
                            }
                            .padding(0)
                            .onAppear {
                                if notes.count == 0 {
                                    addNewNote()
                                }
                                userNote = notes[0].content ?? ""
                            }
                        }
                        // TASKS
                        else {
                            VStack {
                                
                                TextField("Whatcha gonna do?", text: $taskTitle)
                                    .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                                    .textFieldStyle(.plain)
                                    .background(Color("InputBgColor"))
                                    .font(.system(size: 16, weight: .regular))
                                    .cornerRadius(8)
                                    .focused($focusField, equals: .taskField)
                                    .tag("taskTextfield")
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color("HoverColor"), lineWidth: 1)
                                    )
                                    .onSubmit {
                                        let r =  taskTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                        if r != "" {
                                            addTask(_taskTitle: taskTitle)
                                        }
                                    }
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            self.focusField = .taskField
                                        }
                                    }
                                
                            }
                            .padding([.top, .leading, .trailing], 12)
                            
                            
                            if tasks.count == 0{
                                VStack {
                                    
                                    ZStack {
                                        Image(systemName: "tray.fill")
                                            .font(.system(size: 48.0, weight: .light))
                                            .padding(.bottom, 5)
                                            .foregroundColor(Color("TextColor"))
                                            .opacity(0.1)
                                            .onAppear(){confettiCounter += 1}
                                            ConfettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                                    }
                                    
                                    Text("No tasks for today ")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color("TextColor"))
                                        .opacity(0.2)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 360)
                                .padding()
                            } else {
                                ScrollView {
                                    VStack (spacing: 2) {
                                        ForEach(tasks, id:\.wrappedID ) { task in
                                            Group {
                                                HStack {
                                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                                        .resizable()
                                                        .frame(width: 16, height: 16)
                                                        .clipped()
                                                        .foregroundColor(task.isDone ? Color("AccentColor") : Color("TextColor"))
                                                    Text("\(task.wrappedTitle)")
                                                        .strikethrough(task.isDone ? true : false)
                                                        .font(.system(size: 16))
                                                        .foregroundColor(Color("TextColor"))
                                                        .padding(.leading, 2)
                                                        .opacity(task.isDone ? 0.5 : 1)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 10)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .background(self.onHover == tasks.firstIndex(of: task)! ? Color("HoverColor") : .clear)
                                            .onHover { hover in
                                                if hover && tasks.count > 0 {
                                                    self.onHover = tasks.firstIndex(of: task) ?? -1
                                                } else {
                                                    self.onHover = -1
                                                }
                                            }
                                            .onTapGesture {
                                                updateTask(t: task)
                                            }
                                            .contextMenu {
                                                Button(action: {
                                                    deleteTask(t: task)
                                                }, label: {
                                                    Text("Delete")
                                                })
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                    .background(.clear)
                                    .padding(0)
                                }
                                .padding(.vertical, 0)
                                .padding(.horizontal, 12)
                            }
                        }
                        
                    }
                    .background(Color("ContentBgColor"))
                    .onAppear {
                        DisplayMode.changeDisplayMode(to: displayMode)
                    }
                    .onChange(of: displayMode) { newValue in
                        DisplayMode.changeDisplayMode(to: newValue)
                    }
                    
                }
            }
        }
        
    }

    
// -----------------------
// METHODS
// -----------------------
    
    func addTask(_taskTitle:String) {

        let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.title = _taskTitle
            newTask.isDone = false
            newTask.date = Date()

        try? viewContext.save()

        taskTitle = ""

    }

    func updateTask(t: Task){
        t.isDone.toggle()

        if t.isDone && removeCompleted {
            withAnimation(.spring()){
                deleteTask(t: t)
            }
        } else {

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }

        }
    }

    func deleteTask(t: Task){

        viewContext.delete(t)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }

    func deleteAllTasks(){
        for task in tasks {
            withAnimation(.spring()){
                deleteTask(t: task)
            }
        }
    }

    func deleteCheckedTasks(){
        for task in tasks {
            if task.isDone {
                withAnimation(.spring()){
                    deleteTask(t: task)
                }
            }
        }
    }
    
    func addNewNote(){
        let newNote = Notes(context: viewContext)
            newNote.id = UUID()
            newNote.content = ""
            newNote.date = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteNote(n: Notes){
        viewContext.delete(n)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func clearNote(n: Notes){
        n.content = ""
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteAllNotes(){
        
        for note in notes {
            viewContext.delete(note)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        addNewNote()
        userNote = ""
        activeNoteIndex = 0
    }
    
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}


fileprivate struct KeyboardEventModifier: ViewModifier {
    enum Key: String {
        case a, c, v, x
    }

    let key: Key
    let modifiers: EventModifiers

    func body(content: Content) -> some View {
        content.keyboardShortcut(KeyEquivalent(Character(key.rawValue)), modifiers: modifiers)
    }
}

extension View {
    fileprivate func keyboardShortcut(_ key: KeyboardEventModifier.Key, modifiers: EventModifiers = .command) -> some View {
        modifier(KeyboardEventModifier(key: key, modifiers: modifiers))
    }
}
