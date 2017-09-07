/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Alert,
  NativeAppEventEmitter
} from 'react-native';

export default class AwesomeProject extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          This is Push iOS Demo!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }

  componentDidMount() {
    this.subscription1 = NativeAppEventEmitter.addListener(
      'MessageReminder',
      (reminder) => {
        console.log('here1')
        alert(reminder.title + '\n' + reminder.body)
      }
    );

    this.subscription2 = NativeAppEventEmitter.addListener(
      'DeviceIdReminder',
      (reminder) => {
        console.log('here2')
        alert('deviceId: ' + reminder.deviceId)
      }
    );
  }

  componentWillUnmount() {
      this.subscription1.remove()
      this.subscription2.remove()
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('AwesomeProject', () => AwesomeProject);
