package com.shinriyo.subzero

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

class SubzeroPluginTest {
    private lateinit var plugin: SubzeroPlugin
    private lateinit var channel: MethodChannel.Result

    @Before
    fun setUp() {
        plugin = SubzeroPlugin()
        channel = mock(MethodChannel.Result::class.java)
    }

    @Test
    fun `copyWithModel sends correct data`() {
        val properties = mapOf(
            "name" to "Bob",
            "age" to 35
        )
        val arguments = mapOf(
            "className" to "Person",
            "properties" to properties,
            "propertyList" to listOf("name", "age")
        )

        plugin.onMethodCall(
            MethodCall("copyWithModel", arguments),
            channel
        )

        verify(channel).success(properties)
    }

    @Test
    fun `toJson sends correct data`() {
        val arguments = mapOf(
            "className" to "Person",
            "propertyList" to listOf("name", "age")
        )
        val expectedJson = mapOf(
            "name" to "test",
            "age" to 25
        )

        plugin.onMethodCall(
            MethodCall("toJson", arguments),
            channel
        )

        verify(channel).success(expectedJson)
    }
}
