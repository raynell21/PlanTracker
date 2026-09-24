import React, { useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { 
  StyleSheet, Text, View, ScrollView, TouchableOpacity, 
  SafeAreaView, Modal, TextInput, KeyboardAvoidingView, Platform 
} from 'react-native';

export default function App() {
  const [plans, setPlans] = useState([
    { id: '1', title: 'Morning Workout', category: 'Health', time: '07:00 AM', completed: true },
    { id: '2', title: 'React Native Development', category: 'Coding', time: '10:00 AM', completed: false },
    { id: '3', title: 'Read 20 Pages of a Book', category: 'Growth', time: '08:00 PM', completed: false },
  ]);

  const [modalVisible, setModalVisible] = useState(false);
  const [newTitle, setNewTitle] = useState('');
  const [newCategory, setNewCategory] = useState('Growth');
  const [newTime, setNewTime] = useState('12:00 PM');

  const togglePlan = (id) => {
    setPlans(plans.map(plan => plan.id === id ? { ...plan, completed: !plan.completed } : plan));
  };

  const addPlan = () => {
    if (!newTitle.trim()) return;
    const newPlanObj = {
      id: Date.now().toString(),
      title: newTitle,
      category: newCategory,
      time: newTime,
      completed: false,
    };
    setPlans([...plans, newPlanObj]);
    setNewTitle('');
    setModalVisible(false);
  };

  const completedCount = plans.filter(p => p.completed).length;
  const progressPercentage = Math.round((completedCount / plans.length) * 100) || 0;

  const getCategoryColor = (category) => {
    switch (category) {
      case 'Health': return { bg: '#E1F8DC', text: '#2B7A0B' };
      case 'Coding': return { bg: '#E0F2FE', text: '#0369A1' };
      case 'Growth': return { bg: '#FEF3C7', text: '#B45309' };
      default: return { bg: '#EEF2FF', text: '#4F46E5' };
    }
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Hello, Creator! ✨</Text>
            <Text style={styles.subtitle}>Make today count and conquer your goals</Text>
          </View>
          <TouchableOpacity style={styles.addButton} onPress={() => setModalVisible(true)}>
            <Text style={styles.addButtonText}>+</Text>
          </TouchableOpacity>
        </View>

        {/* Progress Card */}
        <View style={styles.progressCard}>
          <View style={styles.progressInfo}>
            <View>
              <Text style={styles.progressTitle}>Daily Momentum</Text>
              <Text style={styles.progressStats}>{completedCount} of {plans.length} tasks completed</Text>
            </View>
            <View style={styles.percentageBadge}>
              <Text style={styles.percentageText}>{progressPercentage}%</Text>
            </View>
          </View>
          <View style={styles.progressBarBackground}>
            <View style={[styles.progressBarFill, { width: `${progressPercentage}%` }]} />
          </View>
        </View>

        {/* Section Title */}
        <Text style={styles.sectionTitle}>Today's Agenda</Text>

        {/* Plans List */}
        <ScrollView showsVerticalScrollIndicator={false} style={styles.planList}>
          {plans.map((plan) => {
            const catColors = getCategoryColor(plan.category);
            return (
              <TouchableOpacity 
                key={plan.id} 
                style={[styles.planCard, plan.completed && styles.planCardCompleted]} 
                onPress={() => togglePlan(plan.id)}
                activeOpacity={0.85}
              >
                <View style={styles.planLeft}>
                  <View style={[styles.checkbox, plan.completed && styles.checkboxChecked]}>
                    {plan.completed && <Text style={styles.checkmark}>✓</Text>}
                  </View>
                  <View style={styles.planTextContainer}>
                    <Text style={[styles.planTitle, plan.completed && styles.planTitleCompleted]}>
                      {plan.title}
                    </Text>
                    <Text style={styles.planTime}>🕒 {plan.time}</Text>
                  </View>
                </View>
                <View style={[styles.categoryBadge, { backgroundColor: catColors.bg }, plan.completed && styles.categoryBadgeCompleted]}>
                  <Text style={[styles.categoryText, { color: catColors.text }, plan.completed && styles.categoryTextCompleted]}>
                    {plan.category}
                  </Text>
                </View>
              </TouchableOpacity>
            );
          })}
        </ScrollView>

        {/* Add Plan Modal */}
        <Modal animationType="slide" transparent={true} visible={modalVisible}>
          <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} style={styles.modalOverlay}>
            <View style={styles.modalContent}>
              <Text style={styles.modalTitle}>New Plan</Text>
              
              <Text style={styles.inputLabel}>Task Title</Text>
              <TextInput 
                style={styles.input} 
                placeholder="e.g., Morning Jog, System Architecture" 
                placeholderTextColor="#94A3B8"
                value={newTitle}
                onChangeText={setNewTitle}
              />

              <Text style={styles.inputLabel}>Category (Health, Coding, Growth)</Text>
              <TextInput 
                style={styles.input} 
                placeholder="Health" 
                placeholderTextColor="#94A3B8"
                value={newCategory}
                onChangeText={setNewCategory}
              />

              <Text style={styles.inputLabel}>Time</Text>
              <TextInput 
                style={styles.input} 
                placeholder="08:00 AM" 
                placeholderTextColor="#94A3B8"
                value={newTime}
                onChangeText={setNewTime}
              />

              <View style={styles.modalButtons}>
                <TouchableOpacity style={[styles.modalBtn, styles.cancelBtn]} onPress={() => setModalVisible(false)}>
                  <Text style={styles.cancelBtnText}>Cancel</Text>
                </TouchableOpacity>
                <TouchableOpacity style={[styles.modalBtn, styles.saveBtn]} onPress={addPlan}>
                  <Text style={styles.saveBtnText}>Save Plan</Text>
                </TouchableOpacity>
              </View>
            </View>
          </KeyboardAvoidingView>
        </Modal>

        <StatusBar style="dark" />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: '#F8FAFC' },
  container: { flex: 1, paddingHorizontal: 20, paddingTop: 20 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 },
  greeting: { fontSize: 24, fontWeight: '700', color: '#0F172A' },
  subtitle: { fontSize: 13, color: '#64748B', marginTop: 3, fontWeight: '500' },
  addButton: { 
    backgroundColor: '#6366F1', width: 48, height: 48, borderRadius: 24, 
    justifyContent: 'center', alignItems: 'center', shadowColor: '#6366F1', 
    shadowOffset: { width: 0, height: 6 }, shadowOpacity: 0.35, shadowRadius: 8, elevation: 6 
  },
  addButtonText: { color: '#FFFFFF', fontSize: 26, fontWeight: '600', marginTop: -2 },
  progressCard: { 
    backgroundColor: '#FFFFFF', borderRadius: 20, padding: 20, marginBottom: 24, 
    shadowColor: '#64748B', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.08, shadowRadius: 12, elevation: 3 
  },
  progressInfo: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 },
  progressTitle: { fontSize: 16, fontWeight: '700', color: '#1E293B' },
  progressStats: { fontSize: 13, color: '#64748B', marginTop: 2, fontWeight: '500' },
  percentageBadge: { backgroundColor: '#EEF2FF', paddingHorizontal: 10, paddingVertical: 6, borderRadius: 10 },
  percentageText: { color: '#6366F1', fontWeight: '700', fontSize: 13 },
  progressBarBackground: { height: 10, backgroundColor: '#F1F5F9', borderRadius: 5, overflow: 'hidden' },
  progressBarFill: { height: '100%', backgroundColor: '#6366F1', borderRadius: 5 },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: '#0F172A', marginBottom: 12 },
  planList: { flex: 1 },
  planCard: { 
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', 
    backgroundColor: '#FFFFFF', padding: 16, borderRadius: 16, marginBottom: 12, 
    borderWidth: 1, borderColor: '#F1F5F9', shadowColor: '#000', shadowOffset: { width: 0, height: 1 }, shadowOpacity: 0.02, shadowRadius: 3, elevation: 1 
  },
  planCardCompleted: { backgroundColor: '#F8FAFC', borderColor: '#E2E8F0', opacity: 0.8 },
  planLeft: { flexDirection: 'row', alignItems: 'center', flex: 1, marginRight: 10 },
  checkbox: { 
    width: 26, height: 26, borderRadius: 8, borderWidth: 2, borderColor: '#CBD5E1', 
    justifyContent: 'center', alignItems: 'center', marginRight: 14, backgroundColor: '#FFFFFF' 
  },
  checkboxChecked: { backgroundColor: '#10B981', borderColor: '#10B981' },
  checkmark: { color: '#FFFFFF', fontSize: 14, fontWeight: 'bold' },
  planTextContainer: { flex: 1 },
  planTitle: { fontSize: 15, fontWeight: '600', color: '#1E293B', marginBottom: 4 },
  planTitleCompleted: { color: '#94A3B8', textDecorationLine: 'line-through' },
  planTime: { fontSize: 12, color: '#64748B', fontWeight: '500' },
  categoryBadge: { paddingHorizontal: 10, paddingVertical: 6, borderRadius: 8 },
  categoryBadgeCompleted: { backgroundColor: '#E2E8F0' },
  categoryText: { fontSize: 11, fontWeight: '600' },
  categoryTextCompleted: { color: '#94A3B8' },
  modalOverlay: { flex: 1, justifyContent: 'flex-end', backgroundColor: 'rgba(15, 23, 42, 0.5)' },
  modalContent: { backgroundColor: '#FFFFFF', borderTopLeftRadius: 24, borderTopRightRadius: 24, padding: 24, paddingBottom: 40 },
  modalTitle: { fontSize: 20, fontWeight: '700', color: '#0F172A', marginBottom: 20 },
  inputLabel: { fontSize: 13, fontWeight: '600', color: '#475569', marginBottom: 6 },
  input: { backgroundColor: '#F8FAFC', borderWidth: 1, borderColor: '#E2E8F0', borderRadius: 12, padding: 14, fontSize: 15, color: '#0F172A', marginBottom: 16 },
  modalButtons: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 10 },
  modalBtn: { flex: 1, paddingVertical: 14, borderRadius: 12, alignItems: 'center' },
  cancelBtn: { backgroundColor: '#F1F5F9', marginRight: 8 },
  cancelBtnText: { color: '#475569', fontWeight: '600', fontSize: 15 },
  saveBtn: { backgroundColor: '#6366F1', marginLeft: 8 },
  saveBtnText: { color: '#FFFFFF', fontWeight: '600', fontSize: 15 }
});