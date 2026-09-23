import React, { useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { 
  StyleSheet, 
  Text, 
  View, 
  ScrollView, 
  TouchableOpacity, 
  SafeAreaView, 
  Modal, 
  TextInput, 
  KeyboardAvoidingView, 
  Platform 
} from 'react-native';

export default function App() {
  const [plans, setPlans] = useState([
    { id: '1', title: 'Morning Workout', category: 'Health', time: '07:00 AM', completed: true },
    { id: '2', title: 'React Native Development', category: 'Coding', time: '10:00 AM', completed: false },
    { id: '3', title: 'Read 20 Pages of a Book', category: 'Growth', time: '08:00 PM', completed: false },
  ]);

  // Filter state ('All', 'Active', 'Completed')
  const [filter, setFilter] = useState('All');

  // Modal visibility and form state
  const [modalVisible, setModalVisible] = useState(false);
  const [newTitle, setNewTitle] = useState('');
  const [newCategory, setNewCategory] = useState('');
  const [newTime, setNewTime] = useState('');

  const togglePlan = (id) => {
    setPlans(plans.map(plan => 
      plan.id === id ? { ...plan, completed: !plan.completed } : plan
    ));
  };

  const deletePlan = (id) => {
    setPlans(plans.filter(plan => plan.id !== id));
  };

  const addPlan = () => {
    if (!newTitle.trim()) return; // Prevent empty plans

    const newPlanObj = {
      id: Date.now().toString(),
      title: newTitle,
      category: newCategory.trim() || 'General',
      time: newTime.trim() || 'Anytime',
      completed: false,
    };

    setPlans([newPlanObj, ...plans]);
    
    // Reset form and close modal
    setNewTitle('');
    setNewCategory('');
    setNewTime('');
    setModalVisible(false);
  };

  // Filtered plans calculation
  const filteredPlans = plans.filter(plan => {
    if (filter === 'Active') return !plan.completed;
    if (filter === 'Completed') return plan.completed;
    return true; // 'All'
  });

  const completedCount = plans.filter(p => p.completed).length;
  const progressPercentage = plans.length > 0 ? Math.round((completedCount / plans.length) * 100) : 0;

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Hello, Tracker! 👋</Text>
            <Text style={styles.subtitle}>Here is your plan for today</Text>
          </View>
          <TouchableOpacity 
            style={styles.addButton} 
            onPress={() => setModalVisible(true)}
            activeOpacity={0.8}
          >
            <Text style={styles.addButtonText}>+</Text>
          </TouchableOpacity>
        </View>

        {/* Progress Card */}
        <View style={styles.progressCard}>
          <View style={styles.progressInfo}>
            <Text style={styles.progressTitle}>Daily Progress</Text>
            <Text style={styles.progressStats}>{completedCount} of {plans.length} completed</Text>
          </View>
          <View style={styles.progressBarBackground}>
            <View style={[styles.progressBarFill, { width: `${progressPercentage}%` }]} />
          </View>
        </View>

        {/* Filter Tabs */}
        <View style={styles.filterContainer}>
          {['All', 'Active', 'Completed'].map((tab) => (
            <TouchableOpacity 
              key={tab} 
              style={[styles.filterTab, filter === tab && styles.filterTabActive]}
              onPress={() => setFilter(tab)}
              activeOpacity={0.8}
            >
              <Text style={[styles.filterTabText, filter === tab && styles.filterTabTextActive]}>
                {tab}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        {/* Section Title */}
        <Text style={styles.sectionTitle}>Your Plans</Text>

        {/* Plans List */}
        <ScrollView showsVerticalScrollIndicator={false} style={styles.planList}>
          {filteredPlans.length === 0 ? (
            <View style={styles.emptyContainer}>
              <Text style={styles.emptyText}>No {filter.toLowerCase()} plans found.</Text>
            </View>
          ) : (
            filteredPlans.map((plan) => (
              <TouchableOpacity 
                key={plan.id} 
                style={[styles.planCard, plan.completed && styles.planCardCompleted]}
                onPress={() => togglePlan(plan.id)}
                activeOpacity={0.8}
              >
                <View style={styles.planLeft}>
                  <View style={[styles.checkbox, plan.completed && styles.checkboxChecked]}>
                    {plan.completed && <Text style={styles.checkmark}>✓</Text>}
                  </View>
                  <View style={styles.planTextContainer}>
                    <Text style={[styles.planTitle, plan.completed && styles.planTitleCompleted]} numberOfLines={1}>
                      {plan.title}
                    </Text>
                    <Text style={styles.planTime}>⏰ {plan.time}</Text>
                  </View>
                </View>

                <View style={styles.planRight}>
                  <View style={[styles.categoryBadge, plan.completed && styles.categoryBadgeCompleted]}>
                    <Text style={[styles.categoryText, plan.completed && styles.categoryTextCompleted]} numberOfLines={1}>
                      {plan.category}
                    </Text>
                  </View>
                  
                  <TouchableOpacity 
                    style={styles.deleteButton} 
                    onPress={() => deletePlan(plan.id)}
                    hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
                  >
                    <Text style={styles.deleteButtonText}>🗑️</Text>
                  </TouchableOpacity>
                </View>
              </TouchableOpacity>
            ))
          )}
        </ScrollView>

        {/* Add Plan Modal Form */}
        <Modal
          animationType="slide"
          transparent={true}
          visible={modalVisible}
          onRequestClose={() => setModalVisible(false)}
        >
          <KeyboardAvoidingView 
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
            style={styles.modalOverlay}
          >
            <View style={styles.modalContent}>
              <View style={styles.modalHeader}>
                <Text style={styles.modalTitle}>Add New Plan</Text>
                <TouchableOpacity onPress={() => setModalVisible(false)}>
                  <Text style={styles.closeButtonText}>✕</Text>
                </TouchableOpacity>
              </View>

              <Text style={styles.inputLabel}>Plan Title</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g., Morning Jog, Study Session"
                placeholderTextColor="#94A3B8"
                value={newTitle}
                onChangeText={setNewTitle}
              />

              <Text style={styles.inputLabel}>Category</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g., Health, Coding, Work"
                placeholderTextColor="#94A3B8"
                value={newCategory}
                onChangeText={setNewCategory}
              />

              <Text style={styles.inputLabel}>Time</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g., 08:30 AM"
                placeholderTextColor="#94A3B8"
                value={newTime}
                onChangeText={setNewTime}
              />

              <View style={styles.modalActions}>
                <TouchableOpacity 
                  style={styles.cancelButton} 
                  onPress={() => setModalVisible(false)}
                >
                  <Text style={styles.cancelButtonText}>Cancel</Text>
                </TouchableOpacity>

                <TouchableOpacity 
                  style={styles.saveButton} 
                  onPress={addPlan}
                >
                  <Text style={styles.saveButtonText}>Add Plan</Text>
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
  safeArea: {
    flex: 1,
    backgroundColor: '#F8F9FA',
  },
  container: {
    flex: 1,
    paddingHorizontal: 20,
    paddingTop: 20,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  greeting: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1A1A1A',
  },
  subtitle: {
    fontSize: 14,
    color: '#6C757D',
    marginTop: 2,
  },
  addButton: {
    backgroundColor: '#4F46E5',
    width: 44,
    height: 44,
    borderRadius: 22,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#4F46E5',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 5,
    elevation: 4,
  },
  addButtonText: {
    color: '#FFFFFF',
    fontSize: 24,
    fontWeight: 'bold',
    marginTop: -2,
  },
  progressCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 20,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 8,
    elevation: 2,
  },
  progressInfo: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  progressTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1A1A1A',
  },
  progressStats: {
    fontSize: 14,
    color: '#6C757D',
    fontWeight: '500',
  },
  progressBarBackground: {
    height: 8,
    backgroundColor: '#E9ECEF',
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressBarFill: {
    height: '100%',
    backgroundColor: '#4F46E5',
    borderRadius: 4,
  },
  filterContainer: {
    flexDirection: 'row',
    backgroundColor: '#E2E8F0',
    borderRadius: 10,
    padding: 4,
    marginBottom: 16,
  },
  filterTab: {
    flex: 1,
    paddingVertical: 8,
    alignItems: 'center',
    borderRadius: 8,
  },
  filterTabActive: {
    backgroundColor: '#FFFFFF',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 1,
  },
  filterTabText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#64748B',
  },
  filterTabTextActive: {
    color: '#4F46E5',
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#1A1A1A',
    marginBottom: 12,
  },
  planList: {
    flex: 1,
  },
  emptyContainer: {
    paddingVertical: 40,
    alignItems: 'center',
  },
  emptyText: {
    color: '#94A3B8',
    fontSize: 15,
  },
  planCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#EFEFEF',
  },
  planCardCompleted: {
    backgroundColor: '#F1F3F5',
    borderColor: '#E2E8F0',
  },
  planLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
    marginRight: 10,
  },
  planTextContainer: {
    flex: 1,
  },
  checkbox: {
    width: 24,
    height: 24,
    borderRadius: 6,
    borderWidth: 2,
    borderColor: '#CBD5E1',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  checkboxChecked: {
    backgroundColor: '#4F46E5',
    borderColor: '#4F46E5',
  },
  checkmark: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
  planTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1E293B',
    marginBottom: 4,
  },
  planTitleCompleted: {
    color: '#94A3B8',
    textDecorationLine: 'line-through',
  },
  planTime: {
    fontSize: 12,
    color: '#64748B',
  },
  planRight: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  categoryBadge: {
    backgroundColor: '#EEF2FF',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
    marginRight: 8,
  },
  categoryBadgeCompleted: {
    backgroundColor: '#E2E8F0',
  },
  categoryText: {
    fontSize: 11,
    color: '#4F46E5',
    fontWeight: '500',
  },
  categoryTextCompleted: {
    color: '#64748B',
  },
  deleteButton: {
    padding: 4,
  },
  deleteButtonText: {
    fontSize: 16,
  },
  modalOverlay: {
    flex: 1,
    justifyContent: 'flex-end',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalContent: {
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
    paddingBottom: 40,
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: '700',
    color: '#1A1A1A',
  },
  closeButtonText: {
    fontSize: 18,
    color: '#64748B',
    fontWeight: 'bold',
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: '#475569',
    marginBottom: 6,
  },
  input: {
    backgroundColor: '#F8FAFC',
    borderWidth: 1,
    borderColor: '#E2E8F0',
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 12,
    fontSize: 16,
    color: '#1E293B',
    marginBottom: 16,
  },
  modalActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 10,
  },
  cancelButton: {
    flex: 1,
    backgroundColor: '#F1F5F9',
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
    marginRight: 8,
  },
  cancelButtonText: {
    color: '#475569',
    fontWeight: '600',
    fontSize: 16,
  },
  saveButton: {
    flex: 1,
    backgroundColor: '#4F46E5',
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
    marginLeft: 8,
  },
  saveButtonText: {
    color: '#FFFFFF',
    fontWeight: '600',
    fontSize: 16,
  },
});