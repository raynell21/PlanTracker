import React, { useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';

export default function App() {
  // Sample state to handle plans dynamically later
  const [plans, setPlans] = useState([
    { id: '1', title: 'Morning Workout', category: 'Health', time: '07:00 AM', completed: true },
    { id: '2', title: 'React Native Development', category: 'Coding', time: '10:00 AM', completed: false },
    { id: '3', title: 'Read 20 Pages of a Book', category: 'Growth', time: '08:00 PM', completed: false },
  ]);

  const togglePlan = (id) => {
    setPlans(plans.map(plan => 
      plan.id === id ? { ...plan, completed: !plan.completed } : plan
    ));
  };

  const completedCount = plans.filter(p => p.completed).length;
  const progressPercentage = Math.round((completedCount / plans.length) * 100) || 0;

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Hello, Tracker! 👋</Text>
            <Text style={styles.subtitle}>Here is your plan for today</Text>
          </View>
          <TouchableOpacity style={styles.addButton}>
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

        {/* Section Title */}
        <Text style={styles.sectionTitle}>Your Plans</Text>

        {/* Plans List */}
        <ScrollView showsVerticalScrollIndicator={false} style={styles.planList}>
          {plans.map((plan) => (
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
                <View>
                  <Text style={[styles.planTitle, plan.completed && styles.planTitleCompleted]}>
                    {plan.title}
                  </Text>
                  <Text style={styles.planTime}>⏰ {plan.time}</Text>
                </View>
              </View>
              <View style={[styles.categoryBadge, plan.completed && styles.categoryBadgeCompleted]}>
                <Text style={[styles.categoryText, plan.completed && styles.categoryTextCompleted]}>
                  {plan.category}
                </Text>
              </View>
            </TouchableOpacity>
          ))}
        </ScrollView>

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
    marginBottom: 24,
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
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: '#1A1A1A',
    marginBottom: 12,
  },
  planList: {
    flex: 1,
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
  categoryBadge: {
    backgroundColor: '#EEF2FF',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
  },
  categoryBadgeCompleted: {
    backgroundColor: '#E2E8F0',
  },
  categoryText: {
    fontSize: 12,
    color: '#4F46E5',
    fontWeight: '500',
  },
  categoryTextCompleted: {
    color: '#64748B',
  },
});