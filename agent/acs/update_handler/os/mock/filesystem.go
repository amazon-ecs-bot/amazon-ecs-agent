// Copyright 2015-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"). You may
// not use this file except in compliance with the License. A copy of the
// License is located at
//
//     http://aws.amazon.com/apache2.0/
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.

// Code generated by MockGen. DO NOT EDIT.
// Source: github.com/aws/amazon-ecs-agent/agent/acs/update_handler/os (interfaces: FileSystem)

// Package mock_os is a generated GoMock package.
package mock_os

import (
	io "io"
	os "os"
	reflect "reflect"

	gomock "github.com/golang/mock/gomock"
)

// MockFileSystem is a mock of FileSystem interface
type MockFileSystem struct {
	ctrl     *gomock.Controller
	recorder *MockFileSystemMockRecorder
}

// MockFileSystemMockRecorder is the mock recorder for MockFileSystem
type MockFileSystemMockRecorder struct {
	mock *MockFileSystem
}

// NewMockFileSystem creates a new mock instance
func NewMockFileSystem(ctrl *gomock.Controller) *MockFileSystem {
	mock := &MockFileSystem{ctrl: ctrl}
	mock.recorder = &MockFileSystemMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockFileSystem) EXPECT() *MockFileSystemMockRecorder {
	return m.recorder
}

// Copy mocks base method
func (m *MockFileSystem) Copy(arg0 io.Writer, arg1 io.Reader) (int64, error) {
	ret := m.ctrl.Call(m, "Copy", arg0, arg1)
	ret0, _ := ret[0].(int64)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Copy indicates an expected call of Copy
func (mr *MockFileSystemMockRecorder) Copy(arg0, arg1 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Copy", reflect.TypeOf((*MockFileSystem)(nil).Copy), arg0, arg1)
}

// Create mocks base method
func (m *MockFileSystem) Create(arg0 string) (io.ReadWriteCloser, error) {
	ret := m.ctrl.Call(m, "Create", arg0)
	ret0, _ := ret[0].(io.ReadWriteCloser)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Create indicates an expected call of Create
func (mr *MockFileSystemMockRecorder) Create(arg0 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Create", reflect.TypeOf((*MockFileSystem)(nil).Create), arg0)
}

// Exit mocks base method
func (m *MockFileSystem) Exit(arg0 int) {
	m.ctrl.Call(m, "Exit", arg0)
}

// Exit indicates an expected call of Exit
func (mr *MockFileSystemMockRecorder) Exit(arg0 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Exit", reflect.TypeOf((*MockFileSystem)(nil).Exit), arg0)
}

// MkdirAll mocks base method
func (m *MockFileSystem) MkdirAll(arg0 string, arg1 os.FileMode) error {
	ret := m.ctrl.Call(m, "MkdirAll", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// MkdirAll indicates an expected call of MkdirAll
func (mr *MockFileSystemMockRecorder) MkdirAll(arg0, arg1 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "MkdirAll", reflect.TypeOf((*MockFileSystem)(nil).MkdirAll), arg0, arg1)
}

// Open mocks base method
func (m *MockFileSystem) Open(arg0 string) (io.ReadWriteCloser, error) {
	ret := m.ctrl.Call(m, "Open", arg0)
	ret0, _ := ret[0].(io.ReadWriteCloser)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Open indicates an expected call of Open
func (mr *MockFileSystemMockRecorder) Open(arg0 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Open", reflect.TypeOf((*MockFileSystem)(nil).Open), arg0)
}

// ReadAll mocks base method
func (m *MockFileSystem) ReadAll(arg0 io.Reader) ([]byte, error) {
	ret := m.ctrl.Call(m, "ReadAll", arg0)
	ret0, _ := ret[0].([]byte)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// ReadAll indicates an expected call of ReadAll
func (mr *MockFileSystemMockRecorder) ReadAll(arg0 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "ReadAll", reflect.TypeOf((*MockFileSystem)(nil).ReadAll), arg0)
}

// Remove mocks base method
func (m *MockFileSystem) Remove(arg0 string) {
	m.ctrl.Call(m, "Remove", arg0)
}

// Remove indicates an expected call of Remove
func (mr *MockFileSystemMockRecorder) Remove(arg0 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Remove", reflect.TypeOf((*MockFileSystem)(nil).Remove), arg0)
}

// Rename mocks base method
func (m *MockFileSystem) Rename(arg0, arg1 string) error {
	ret := m.ctrl.Call(m, "Rename", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// Rename indicates an expected call of Rename
func (mr *MockFileSystemMockRecorder) Rename(arg0, arg1 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Rename", reflect.TypeOf((*MockFileSystem)(nil).Rename), arg0, arg1)
}

// TeeReader mocks base method
func (m *MockFileSystem) TeeReader(arg0 io.Reader, arg1 io.Writer) io.Reader {
	ret := m.ctrl.Call(m, "TeeReader", arg0, arg1)
	ret0, _ := ret[0].(io.Reader)
	return ret0
}

// TeeReader indicates an expected call of TeeReader
func (mr *MockFileSystemMockRecorder) TeeReader(arg0, arg1 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "TeeReader", reflect.TypeOf((*MockFileSystem)(nil).TeeReader), arg0, arg1)
}

// TempFile mocks base method
func (m *MockFileSystem) TempFile(arg0, arg1 string) (*os.File, error) {
	ret := m.ctrl.Call(m, "TempFile", arg0, arg1)
	ret0, _ := ret[0].(*os.File)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// TempFile indicates an expected call of TempFile
func (mr *MockFileSystemMockRecorder) TempFile(arg0, arg1 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "TempFile", reflect.TypeOf((*MockFileSystem)(nil).TempFile), arg0, arg1)
}

// WriteFile mocks base method
func (m *MockFileSystem) WriteFile(arg0 string, arg1 []byte, arg2 os.FileMode) error {
	ret := m.ctrl.Call(m, "WriteFile", arg0, arg1, arg2)
	ret0, _ := ret[0].(error)
	return ret0
}

// WriteFile indicates an expected call of WriteFile
func (mr *MockFileSystemMockRecorder) WriteFile(arg0, arg1, arg2 interface{}) *gomock.Call {
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "WriteFile", reflect.TypeOf((*MockFileSystem)(nil).WriteFile), arg0, arg1, arg2)
}
