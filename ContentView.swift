import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Easy Health")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                NavigationLink(destination: GetStartedView()) {
                    Text("Get Started")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationBarTitle(Text("Welcome Screen"), displayMode: .large)
        }
    }
}

//Navigation screen
struct GetStartedView: View {
    var body: some View {
        VStack {
            Text("Choose an Option")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            NavigationLink(destination: LogFoodView()) {
                Text("Log Food")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(10)
                    .padding()
            }
            
            NavigationLink(destination: ImmunizationsView()) {
                Text("Immunizations")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(10)
                    .padding()
            }
            
            NavigationLink(destination: SymptomCheckerView()) {
                Text("Symptom Checker")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(10)
                    .padding()
            }
            
            // Add NavigationLink to Medication Tracker View
                            NavigationLink(destination: MedicationTrackerView()) {
                                Text("Medication Tracker")
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("PrimaryColor"))
                                    .cornerRadius(10)
                                    .padding()
                            }
                            
                            // Add NavigationLink to Fitness Tracker View
                            NavigationLink(destination: FitnessTrackerView()) {
                                Text("Fitness Tracker")
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("PrimaryColor"))
                                    .cornerRadius(10)
                                    .padding()
                            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Main Menu"), displayMode: .large)
    }
}

//Creates 4 lists for each meal of the day. When you click on each icon (inbuilt through Swift), it adds the food in the food name and the calories to the respective list. When each icon is clicked, it goes throguh eaach element in the list and displays it to the screen.
struct LogFoodView: View {
    enum Meal: String, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snacks = "Snacks"
    }
    
    @State private var selectedMeal: Meal = .breakfast
    @State private var foodName = ""
    @State private var calories = ""
    
    @State private var foodLogs: [Meal: [String]] = [
        .breakfast: [],
        .lunch: [],
        .dinner: [],
        .snacks: []
    ]
    
    var body: some View {
        VStack {
            Text("Log Food")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Spacer()
            
            HStack {
                Image(systemName: "sunrise")
                    .font(.system(size: 25))
                    .foregroundColor(selectedMeal == .breakfast ? .primary : .gray)
                    .onTapGesture {
                        selectedMeal = .breakfast
                    }
                
                Image(systemName: "sun.max")
                    .font(.system(size: 25))
                    .foregroundColor(selectedMeal == .lunch ? .primary : .gray)
                    .onTapGesture {
                        selectedMeal = .lunch
                    }
                
                Image(systemName: "sunset")
                    .font(.system(size: 25))
                    .foregroundColor(selectedMeal == .dinner ? .primary : .gray)
                    .onTapGesture {
                        selectedMeal = .dinner
                    }
                
                Image(systemName: "bag")
                    .font(.system(size: 25))
                    .foregroundColor(selectedMeal == .snacks ? .primary : .gray)
                    .onTapGesture {
                        selectedMeal = .snacks
                    }
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            VStack {
                TextField("Food Name", text: $foodName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                TextField("Calories", text: $calories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                Button(action: {
                    saveFoodLog()
                }) {
                    Text("Save")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
                
                Divider()
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(foodLogs[selectedMeal] ?? [], id: \.self) { food in
                            Text(food)
                                .font(.headline)
                                .padding()
                                .background(Color("SecondaryColor"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
        }
    }
    
    private func saveFoodLog() {
        guard !foodName.isEmpty, !calories.isEmpty else { return }
        
        let newFoodLog = "\(foodName) - \(calories) Calories"
        foodLogs[selectedMeal]?.append(newFoodLog)
        
        foodName = ""
        calories = ""
    }
}


//Has a map of symtpoms and stores the symptoms the user enters (symptoms displayed in a table). Then, for each disease, it checks how many symptoms match out of its pool and divides that by the total possible symtpoms. It then displays the top three most likely diseases by showing the hgiehst numbers first.
struct SymptomCheckerView: View {
    @State private var searchText = ""
    @State private var selectedSymptoms: Set<Symptom> = []
    @State private var selectedSymptomsList: [Symptom] = []
    @State private var likelyDiseases: [String] = []
    @State private var showLikelyDiseases = false
    
    let allSymptoms: [Symptom] = [
            Symptom(name: "Headache", diseases: ["Migraine", "Tension headache", "Sinusitis", "Common cold"]),
            Symptom(name: "Fatigue", diseases: ["Chronic fatigue syndrome", "Anemia", "Depression"]),
            Symptom(name: "Shortness of breath", diseases: ["Asthma", "Pneumonia", "Chronic obstructive pulmonary disease"]),
            Symptom(name: "Nausea", diseases: ["Food poisoning", "Viral gastroenteritis", "Migraine"]),
            Symptom(name: "Abdominal pain", diseases: ["Appendicitis", "Gastritis", "Irritable bowel syndrome"]),
            Symptom(name: "Diarrhea", diseases: ["Gastroenteritis", "Food poisoning", "Inflammatory bowel disease"]),
            Symptom(name: "Constipation", diseases: ["Hemorrhoids", "Irritable bowel syndrome", "Colon cancer"]),
            Symptom(name: "Vomiting", diseases: ["Gastroenteritis", "Food poisoning", "Morning sickness"]),
            Symptom(name: "Fever", diseases: ["Influenza", "COVID-19", "Common cold"]),
            Symptom(name: "Back pain", diseases: ["Muscle strain", "Herniated disc", "Arthritis"]),
            Symptom(name: "Joint pain", diseases: ["Osteoarthritis", "Rheumatoid arthritis", "Gout"]),
            Symptom(name: "Muscle pain", diseases: ["Fibromyalgia", "Muscle strain", "Polymyalgia rheumatica"]),
            Symptom(name: "Sore throat", diseases: ["Strep throat", "Common cold", "Tonsillitis"]),
            Symptom(name: "Chest pain", diseases: ["Heart attack", "Angina", "Gastroesophageal reflux disease"]),
            Symptom(name: "Palpitations", diseases: ["Atrial fibrillation", "Anxiety", "Hyperthyroidism"]),
            Symptom(name: "High blood pressure", diseases: ["Hypertension", "Kidney disease", "Stress"]),
            Symptom(name: "Low blood pressure", diseases: ["Dehydration", "Anemia", "Septic shock"]),
            Symptom(name: "Rash", diseases: ["Eczema", "Contact dermatitis", "Psoriasis"]),
            Symptom(name: "Itching", diseases: ["Allergies", "Dry skin", "Insect bites"]),
            Symptom(name: "Hair loss", diseases: ["Alopecia areata", "Hypothyroidism", "Iron deficiency"]),
            Symptom(name: "Insomnia", diseases: ["Insomnia disorder", "Sleep apnea", "Restless legs syndrome"]),
            Symptom(name: "Cough", diseases: ["Bronchitis", "Pneumonia", "Asthma"]),
            Symptom(name: "Anxiety", diseases: ["Generalized anxiety disorder", "Panic disorder", "Social anxiety disorder"]),
            Symptom(name: "Depression", diseases: ["Major depressive disorder", "Bipolar disorder", "Postpartum depression"]),
            Symptom(name: "Mood swings", diseases: ["Bipolar disorder", "Premenstrual syndrome", "Menopause"]),
            Symptom(name: "Weight gain", diseases: ["Hypothyroidism", "Polycystic ovary syndrome", "Cushing's syndrome"]),
            Symptom(name: "Weight loss", diseases: ["Hyperthyroidism", "Diabetes", "Cancer"]),
            Symptom(name: "Frequent urination", diseases: ["Urinary tract infection", "Diabetes", "Overactive bladder"]),
            Symptom(name: "Blood in urine", diseases: ["Urinary tract infection", "Kidney stones", "Bladder cancer"]),
            Symptom(name: "Dizziness", diseases: ["Common cold", "Vertigo", "Low blood pressure", "Anxiety"]),
            Symptom(name: "Chest congestion", diseases: ["Bronchitis", "Pneumonia", "COPD"]),
            Symptom(name: "Runny nose", diseases: ["Common cold", "Allergies", "Sinusitis"]),
            Symptom(name: "Sneezing", diseases: ["Allergies", "Common cold", "Hay fever"]),
            Symptom(name: "Watery eyes", diseases: ["Allergies", "Conjunctivitis", "Dry eyes"]),
            Symptom(name: "Swollen lymph nodes", diseases: ["Mononucleosis", "Strep throat", "HIV/AIDS"]),
            Symptom(name: "Sweating", diseases: ["Hyperhidrosis", "Menopause", "Anxiety"]),
            Symptom(name: "Frequent headaches", diseases: ["Migraine", "Tension headache", "Cluster headache"]),
            Symptom(name: "Memory problems", diseases: ["Alzheimer's disease", "Dementia", "Depression"]),
            Symptom(name: "Confusion", diseases: ["Delirium", "Alzheimer's disease", "Brain tumor"]),
            Symptom(name: "Difficulty concentrating", diseases: ["Attention deficit hyperactivity disorder", "Anxiety", "Depression"]),
            Symptom(name: "Abnormal bleeding", diseases: ["Menorrhagia", "Hemophilia", "Gastrointestinal bleeding"]),
            Symptom(name: "Irregular periods", diseases: ["Polycystic ovary syndrome", "Thyroid disorders", "Premature ovarian failure"]),
            Symptom(name: "Missed periods", diseases: ["Pregnancy", "Polycystic ovary syndrome", "Menopause"]),
            Symptom(name: "Joint swelling", diseases: ["Rheumatoid arthritis", "Osteoarthritis", "Gout"]),
            Symptom(name: "Red or swollen tonsils", diseases: ["Strep throat", "Tonsillitis", "Mononucleosis"]),
            Symptom(name: "Blurred vision", diseases: ["Myopia", "Hyperopia", "Glaucoma"]),
            Symptom(name: "Abnormal moles", diseases: ["Melanoma", "Atypical nevus", "Seborrheic keratosis"]),
            Symptom(name: "Muscle weakness", diseases: ["Common cold", "Myasthenia gravis", "Muscular dystrophy", "Multiple sclerosis"]),
            Symptom(name: "Frequent bruising", diseases: ["Hemophilia", "Leukemia", "Vitamin K deficiency"]),
            Symptom(name: "Swollen ankles", diseases: ["Edema", "Heart failure", "Kidney disease"]),
            Symptom(name: "Acne", diseases: ["Acne vulgaris", "Cystic acne", "Hormonal acne"]),
            Symptom(name: "Tingling or numbness", diseases: ["Peripheral neuropathy", "Multiple sclerosis", "Diabetes"]),
            Symptom(name: "Stomach cramps", diseases: ["Gastroenteritis", "Food poisoning", "Irritable bowel syndrome"]),
            Symptom(name: "Joint stiffness", diseases: ["Arthritis", "Rheumatoid arthritis", "Osteoarthritis"]),
            Symptom(name: "Chest tightness", diseases: ["Asthma", "Anxiety", "Heart attack"]),
            Symptom(name: "Frequent thirst", diseases: ["Diabetes", "Dehydration", "Hypercalcemia"]),
            Symptom(name: "Difficulty swallowing", diseases: ["Dysphagia", "GERD", "Throat cancer"]),
            Symptom(name: "Lightheadedness", diseases: ["Orthostatic hypotension", "Dehydration", "Anemia"]),
            Symptom(name: "Frequent hiccups", diseases: ["Gastroesophageal reflux disease", "Achalasia", "Pneumonia"]),
            Symptom(name: "Swollen or painful joints", diseases: ["Arthritis", "Rheumatoid arthritis", "Gout"]),
            Symptom(name: "Excessive thirst", diseases: ["Diabetes", "Hypercalcemia", "Psychogenic polydipsia"]),
            Symptom(name: "Bloating", diseases: ["Irritable bowel syndrome", "Gastroenteritis", "Celiac disease"]),
            Symptom(name: "Cramping", diseases: ["Menstrual cramps", "Gastroenteritis", "Irritable bowel syndrome"]),
            Symptom(name: "Nasal discharge", diseases: ["Common cold", "Sinusitis", "Allergies"]),
            Symptom(name: "Frequent urination at night", diseases: ["Nocturia", "Enlarged prostate", "Diabetes"]),
            Symptom(name: "Sudden weight loss", diseases: ["Hyperthyroidism", "Diabetes", "Cancer"]),
            Symptom(name: "Persistent cough", diseases: ["Chronic bronchitis", "Lung cancer", "Bronchiectasis"]),
            Symptom(name: "Frequent nosebleeds", diseases: ["Epistaxis", "Nasal dryness", "Hypertension"]),
            Symptom(name: "Joint redness", diseases: ["Rheumatoid arthritis", "Osteoarthritis", "Gout"]),
            Symptom(name: "Pain or burning during urination", diseases: ["Urinary tract infection", "Sexually transmitted infections", "Interstitial cystitis"]),
            Symptom(name: "Visible blood in stool", diseases: ["Hemorrhoids", "Colon cancer", "Inflammatory bowel disease"]),
            Symptom(name: "Facial swelling", diseases: ["Allergic reaction", "Angioedema", "Facial cellulitis"]),
            Symptom(name: "Excessive drooling", diseases: ["Salivary gland disorders", "Neurological conditions", "Tooth decay"]),
            Symptom(name: "Painful or frequent urination", diseases: ["Urinary tract infection", "Bladder infection", "Kidney stones"]),
            Symptom(name: "Unexplained weight gain", diseases: ["Hypothyroidism", "Polycystic ovary syndrome", "Cushing's syndrome"]),
            Symptom(name: "Tremors", diseases: ["Parkinson's disease", "Essential tremor", "Multiple sclerosis"]),
            Symptom(name: "Loss of balance", diseases: ["Vertigo", "Inner ear disorders", "Neurological conditions"]),
            Symptom(name: "Muscle twitching", diseases: ["Benign fasciculation syndrome", "Amyotrophic lateral sclerosis", "Electrolyte imbalances"]),
            Symptom(name: "Difficulty speaking", diseases: ["Speech disorders", "Neurological conditions", "Stroke"]),
            Symptom(name: "Hoarseness", diseases: ["Laryngitis", "Thyroid disorders", "Throat cancer"]),
            Symptom(name: "Swelling in the face or extremities", diseases: ["Edema", "Allergic reaction", "Kidney disease"]),
            Symptom(name: "Impaired coordination", diseases: ["Cerebellar ataxia", "Multiple sclerosis", "Brain injury"]),
            Symptom(name: "Vision changes", diseases: ["Macular degeneration", "Glaucoma", "Retinal detachment"])
            ]


    var filteredSymptoms: [Symptom] {
        if searchText.isEmpty {
            return allSymptoms
        } else {
            return allSymptoms.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            Text("Symptom Checker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Spacer()
            
            if !showLikelyDiseases {
                VStack {
                    TextField("Search Symptoms", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(filteredSymptoms, id: \.self) { symptom in
                                Button(action: {
                                    toggleSymptom(symptom)
                                }) {
                                    HStack {
                                        Text(symptom.name)
                                        Spacer()
                                        if selectedSymptoms.contains(symptom) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .padding(.horizontal, 20)
                
                VStack {
                    Text("Selected Symptoms:")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                            ForEach(selectedSymptomsList, id: \.self) { symptom in
                                Text(symptom.name)
                                    .font(.subheadline)
                                    .padding(.vertical, 5)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    findLikelyDiseases()
                    showLikelyDiseases = true
                }) {
                    Text("Find Likely Diseases")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
                .disabled(selectedSymptoms.isEmpty)
            }
            
            if showLikelyDiseases {
                VStack {
                    Text("Likely Diseases:")
                        .font(.title)
                        .padding(.bottom, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(likelyDiseases, id: \.self) { disease in
                                Text(disease)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        resetSymptomChecker()
                    }) {
                        Text("Reset")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
    
    func toggleSymptom(_ symptom: Symptom) {
            if selectedSymptoms.contains(symptom) {
                selectedSymptoms.remove(symptom)
                selectedSymptomsList.removeAll(where: { $0.name == symptom.name })
            } else {
                selectedSymptoms.insert(symptom)
                selectedSymptomsList.append(symptom)
            }
        }
    
    private func findLikelyDiseases() {
        var diseaseScores: [String: Double] = [:]
        var totalSymptomCount = 0
        
        //Find how many symtpoms each disease had
        for symptom in selectedSymptoms {
            totalSymptomCount += symptom.diseases.count
        }
        
        for symptom in selectedSymptoms {
            for disease in symptom.diseases {
                //Divide by the amount of symptoms that the disease had listed
                diseaseScores[disease, default: 0.0] += 1.0 / Double(totalSymptomCount)
            }
        }
        
        let sortedDiseases = diseaseScores.sorted { $0.value > $1.value }
        
        likelyDiseases = sortedDiseases.prefix(3).map { $0.key }
    }

    
    func resetSymptomChecker() {
        searchText = ""
        selectedSymptoms = []
        selectedSymptomsList = []
        likelyDiseases = []
        showLikelyDiseases = false
    }
}

struct Symptom: Hashable {
    let name: String
    let diseases: [String]
}


import UIKit

struct Vaccination: Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var photo: UIImage?
    var additionalDetails: String?
}

struct ImmunizationsView: View {
    @State private var vaccinations: [Vaccination] = []
    @State private var newVaccinationName = ""
    @State private var newVaccinationDate = Date()
    @State private var newVaccinationPhoto: UIImage? = nil
    @State private var newVaccinationDetails = ""
    @State private var selectedVaccination: Vaccination?
    @State private var isShowingImagePicker = false

    var body: some View {
        VStack {
            Text("Immunizations")
                .font(.title)
                .padding()
            
            List {
                ForEach(vaccinations) { vaccination in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vaccination.name)
                                .font(.headline)
                            Spacer()
                            Text("\(vaccination.date)")
                                .font(.subheadline)
                        }
                        
                        vaccination.photo.map {
                            Image(uiImage: $0)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .onTapGesture {
                                    selectedVaccination = vaccination
                                }
                                .sheet(item: $selectedVaccination) { vaccination in
                                    PhotoDetailView(vaccination: vaccination)
                                }
                        }
                        
                        Text(vaccination.additionalDetails ?? "")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
            }
            
            VStack {
                Text("Vaccinations/Immunizations")
                    .font(.headline)
                    .padding()
                
                TextField("Name", text: $newVaccinationName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("Date", selection: $newVaccinationDate, displayedComponents: .date)
                    .padding()
                
                TextField("Additional Details", text: $newVaccinationDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    Text("Add Photo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: addVaccination) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $newVaccinationPhoto, isPresented: $isShowingImagePicker)
        }
    }
    
    func addVaccination() {
        let newVaccination = Vaccination(name: newVaccinationName, date: newVaccinationDate, photo: newVaccinationPhoto, additionalDetails: newVaccinationDetails.isEmpty ? nil : newVaccinationDetails)
        vaccinations.append(newVaccination)
        
        // Reset the input fields
        newVaccinationName = ""
        newVaccinationDate = Date()
        newVaccinationPhoto = nil
        newVaccinationDetails = ""
    }
}


struct PhotoDetailView: View {
    let vaccination: Vaccination
    
    var body: some View {
        VStack {
            Text(vaccination.name)
                .font(.title)
                .padding()
            
            vaccination.photo.map {
                Image(uiImage: $0)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            
            Text(vaccination.additionalDetails ?? "")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding()
            
            Spacer()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var image: UIImage?
        
        init(presentationMode: Binding<PresentationMode>, image: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                image = selectedImage
            }
            
            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}

// Medication.swift
struct Medication: Identifiable {
    var id = UUID()
    var name: String
    var dosage: String
    var reminders: [Date]
    var isTaken: Bool = false
}

// MedicationTrackerView.swift
struct MedicationTrackerView: View {
    @State private var medications: [Medication] = []
    @State private var newMedicationName = ""
    @State private var newMedicationDosage = ""
    @State private var newMedicationReminder = Date()
    
    var body: some View {
        VStack {
            Text("Medication Tracker")
                .font(.title)
                .padding()
            
            List {
                ForEach(medications) { medication in
                    HStack {
                        Text(medication.name)
                            .font(.headline)
                        Spacer()
                        Text("Dosage: \(medication.dosage)")
                        Spacer()
                        Button(action: {
                            markMedicationAsTaken(medication: medication)
                        }) {
                            if medication.isTaken {
                                Text("Taken")
                                    .foregroundColor(.green)
                            } else {
                                Text("Not Taken")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            
            VStack {
                Text("Add Medication")
                    .font(.headline)
                    .padding()
                
                TextField("Name", text: $newMedicationName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Dosage", text: $newMedicationDosage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("Reminder", selection: $newMedicationReminder, displayedComponents: .hourAndMinute)
                    .padding()
                
                Button(action: addMedication) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    
    func addMedication() {
        let newMedication = Medication(name: newMedicationName, dosage: newMedicationDosage, reminders: [newMedicationReminder])
        medications.append(newMedication)
        
        // Reset input fields
        newMedicationName = ""
        newMedicationDosage = ""
    }
    
    func markMedicationAsTaken(medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
        }
    }
}

// Exercise.swift
struct Exercise: Identifiable {
    var id = UUID()
    var name: String
    var duration: String
    var date: Date
}

// FitnessTrackerView.swift
struct FitnessTrackerView: View {
    @State private var exercises: [Exercise] = []
    @State private var newExerciseName = ""
    @State private var newExerciseDuration = ""
    @State private var newExerciseDate = Date()
    
    var body: some View {
        VStack {
            Text("Fitness Tracker")
                .font(.title)
                .padding()
            
            List {
                ForEach(exercises) { exercise in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(exercise.name)
                                .font(.headline)
                            Spacer()
                            Text("\(exercise.duration) mins")
                            Spacer()
                            Text("\(exercise.date, formatter: dateFormatter)")
                        }
                    }
                }
            }
            
            VStack {
                Text("Add Exercise")
                    .font(.headline)
                    .padding()
                
                TextField("Exercise Name", text: $newExerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Duration (mins)", text: $newExerciseDuration)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("Date", selection: $newExerciseDate, displayedComponents: .date)
                    .padding()
                
                Button(action: addExercise) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    
    func addExercise() {
        let newExercise = Exercise(name: newExerciseName, duration: newExerciseDuration, date: newExerciseDate)
        exercises.append(newExercise)
        
        // Reset input fields
        newExerciseName = ""
        newExerciseDuration = ""
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
