# ============================================================
# MuleSoft Secure Properties Tool - Modern Responsive GUI
# ============================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ============================================================
# STATIC CONFIGURATION
# Change only this location if the JAR file moves.
# ============================================================
# ============================================================
# JAR LOCATION
#
# Development mode:
# Uses the JAR from the local development location.
#
# Packaged EXE mode:
# Uses the JAR extracted from the embedded EXE resource.
# ============================================================

$EmbeddedJarPath = Join-Path `
    $env:LOCALAPPDATA `
    "Takeda\MuleSoftSecureProperties\secure-properties-tool-j17.jar"

$DevelopmentJarPath = "C:\Users\qlg9915\OneDrive - Takeda\Documents\Takeda documents\MuleSoft\Secure properties jar\secure-properties-tool-j17.jar"

if (Test-Path -LiteralPath $EmbeddedJarPath -PathType Leaf) {
    $JarPath = $EmbeddedJarPath
}
else {
    $JarPath = $DevelopmentJarPath
}


$JavaExecutable = "java"

if (-not (Test-Path -LiteralPath $JarPath -PathType Leaf)) {
    [System.Windows.MessageBox]::Show(
        "Secure Properties Tool JAR was not found.`n`nExpected location:`n$JarPath`n`nUpdate the JarPath variable in SecurePropertiesGUI.ps1.",
        "JAR File Not Found",
        "OK",
        "Error"
    )
    exit 1
}

# ============================================================
# User Interface
# ============================================================
[xml]$xaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="MuleSoft Secure Properties Tool"
    Width="980"
    Height="790"
    MinWidth="860"
    MinHeight="650"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanResizeWithGrip"
    Background="#F5F7FB"
    FontFamily="Segoe UI">

    <Window.Resources>

        <Style TargetType="Label">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="#344054"/>
            <Setter Property="Margin" Value="0,0,0,5"/>
        </Style>

        <Style TargetType="TextBox">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="10,7"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#C7D4E3"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>

        <Style TargetType="PasswordBox">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="10,7"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#C7D4E3"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>

        <Style x:Key="CardStyle" TargetType="Border">
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#DFE7F0"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="14"/>
            <Setter Property="Padding" Value="22"/>
        </Style>

        <Style x:Key="PrimaryButton" TargetType="Button">
            <Setter Property="Height" Value="40"/>
            <Setter Property="Padding" Value="18,0"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Background" Value="#1769AA"/>
            <Setter Property="BorderBrush" Value="#1769AA"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#0D5D9B"/>
                    <Setter Property="BorderBrush" Value="#0D5D9B"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Opacity" Value="0.55"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="SecondaryButton" TargetType="Button">
            <Setter Property="Height" Value="40"/>
            <Setter Property="Padding" Value="15,0"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="#344054"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#C7D4E3"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#EEF5FC"/>
                    <Setter Property="BorderBrush" Value="#7AAEDD"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Opacity" Value="0.55"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Full-width modern dropdown -->
        <Style x:Key="ModernComboBox" TargetType="ComboBox">
            <Setter Property="Height" Value="40"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="#1D2939"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#CBD8E6"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
            <Setter Property="VerticalContentAlignment" Value="Stretch"/>
            <Setter Property="MaxDropDownHeight" Value="260"/>

            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid HorizontalAlignment="Stretch" VerticalAlignment="Stretch">

                            <ToggleButton
                                x:Name="ToggleButton"
                                Style="{x:Null}"
                                Background="Transparent"
                                BorderThickness="0"
                                Padding="0"
                                Focusable="False"
                                ClickMode="Press"
                                HorizontalContentAlignment="Stretch"
                                VerticalContentAlignment="Stretch"
                                HorizontalAlignment="Stretch"
                                VerticalAlignment="Stretch"
                                IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}">

                                <Border
                                    x:Name="OuterBorder"
                                    Background="{TemplateBinding Background}"
                                    BorderBrush="{TemplateBinding BorderBrush}"
                                    BorderThickness="{TemplateBinding BorderThickness}"
                                    CornerRadius="8"
                                    HorizontalAlignment="Stretch"
                                    VerticalAlignment="Stretch">

                                    <Grid HorizontalAlignment="Stretch" VerticalAlignment="Stretch">
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="42"/>
                                        </Grid.ColumnDefinitions>

                                        <ContentPresenter
                                            Margin="12,0,8,0"
                                            VerticalAlignment="Center"
                                            HorizontalAlignment="Left"
                                            Content="{TemplateBinding SelectionBoxItem}"
                                            ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                                            ContentStringFormat="{TemplateBinding SelectionBoxItemStringFormat}"/>

                                        <Border Grid.Column="1" Background="Transparent">
                                            <Path
                                                Width="10"
                                                Height="6"
                                                Fill="#667085"
                                                Stretch="Fill"
                                                HorizontalAlignment="Center"
                                                VerticalAlignment="Center"
                                                Data="M 0 0 L 10 0 L 5 6 Z"/>
                                        </Border>
                                    </Grid>
                                </Border>
                            </ToggleButton>

                            <Popup
                                x:Name="Popup"
                                Placement="Bottom"
                                AllowsTransparency="True"
                                Focusable="False"
                                PopupAnimation="Fade"
                                IsOpen="{TemplateBinding IsDropDownOpen}">

                                <Border
                                    MinWidth="{Binding ActualWidth, RelativeSource={RelativeSource TemplatedParent}}"
                                    Margin="0,5,0,0"
                                    Background="White"
                                    BorderBrush="#CBD8E6"
                                    BorderThickness="1"
                                    CornerRadius="8">

                                    <Border.Effect>
                                        <DropShadowEffect
                                            BlurRadius="14"
                                            ShadowDepth="3"
                                            Opacity="0.16"
                                            Color="#334155"/>
                                    </Border.Effect>

                                    <ScrollViewer
                                        Margin="4"
                                        CanContentScroll="True"
                                        VerticalScrollBarVisibility="Auto">

                                        <ItemsPresenter/>
                                    </ScrollViewer>
                                </Border>
                            </Popup>
                        </Grid>

                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="OuterBorder" Property="BorderBrush" Value="#5799D0"/>
                                <Setter TargetName="OuterBorder" Property="Background" Value="#FAFDFF"/>
                            </Trigger>
                            <Trigger Property="IsKeyboardFocusWithin" Value="True">
                                <Setter TargetName="OuterBorder" Property="BorderBrush" Value="#1769AA"/>
                                <Setter TargetName="OuterBorder" Property="BorderThickness" Value="2"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="OuterBorder" Property="Opacity" Value="0.55"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBoxItem">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="#344054"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Padding" Value="11,8"/>

            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBoxItem">
                        <Border
                            x:Name="ItemBorder"
                            Background="{TemplateBinding Background}"
                            CornerRadius="5"
                            Padding="{TemplateBinding Padding}">

                            <ContentPresenter
                                VerticalAlignment="Center"
                                HorizontalAlignment="Left"/>
                        </Border>

                        <ControlTemplate.Triggers>
                            <Trigger Property="IsHighlighted" Value="True">
                                <Setter TargetName="ItemBorder" Property="Background" Value="#EAF4FE"/>
                                <Setter Property="Foreground" Value="#1769AA"/>
                            </Trigger>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="ItemBorder" Property="Background" Value="#D8ECFF"/>
                                <Setter Property="Foreground" Value="#0D5D9B"/>
                                <Setter Property="FontWeight" Value="SemiBold"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="84"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="46"/>
        </Grid.RowDefinitions>

        <!-- Header -->
        <Border Grid.Row="0" Background="#123B63" Padding="28,15">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <Border
                    Width="48"
                    Height="48"
                    CornerRadius="12"
                    Background="#2D83CC"
                    VerticalAlignment="Center">

                    <TextBlock
                        Text="MS"
                        Foreground="White"
                        FontSize="17"
                        FontWeight="Bold"
                        HorizontalAlignment="Center"
                        VerticalAlignment="Center"/>
                </Border>

                <StackPanel Grid.Column="1" Margin="14,0,0,0" VerticalAlignment="Center">
                    <TextBlock
                        Text="MuleSoft Secure Properties Tool"
                        Foreground="White"
                        FontSize="21"
                        FontWeight="SemiBold"/>

                    <TextBlock
                        Text="Encrypt, decrypt, preview, copy, and export secure properties"
                        Foreground="#D7ECFF"
                        FontSize="11"
                        Margin="0,3,0,0"/>
                </StackPanel>

                <Border
                    Grid.Column="2"
                    Background="#1C5281"
                    CornerRadius="12"
                    Padding="11,6"
                    VerticalAlignment="Center">

                    <TextBlock
                        Text="Java 17"
                        FontSize="11"
                        Foreground="#D7ECFF"/>
                </Border>
            </Grid>
        </Border>

        <!-- Main Content -->
        <ScrollViewer
            Grid.Row="1"
            VerticalScrollBarVisibility="Auto"
            HorizontalScrollBarVisibility="Disabled">

            <Grid Margin="24">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="14"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="14"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <!-- Configuration -->
                <Border Grid.Row="0" Style="{StaticResource CardStyle}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="14"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="10"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel>
                                <TextBlock
                                    Text="Configuration"
                                    FontSize="17"
                                    FontWeight="SemiBold"
                                    Foreground="#1D2939"/>

                                <TextBlock
                                    Text="Select how the tool should process your secure properties."
                                    FontSize="11"
                                    Foreground="#667085"
                                    Margin="0,4,0,0"/>
                            </StackPanel>

                            <Border
                                Grid.Column="1"
                                Background="#EAF4FE"
                                CornerRadius="12"
                                Padding="10,5"
                                VerticalAlignment="Top">

                                <TextBlock
                                    Text="Security settings"
                                    Foreground="#1769AA"
                                    FontSize="10"/>
                            </Border>
                        </Grid>

                        <Grid Grid.Row="2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="1.4*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="110"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel Grid.Column="0">
                                <Label Content="Operation"/>
                                <ComboBox
                                    x:Name="cmbOperation"
                                    Style="{StaticResource ModernComboBox}"
                                    SelectedIndex="0">
                                    <ComboBoxItem Content="Encrypt"/>
                                    <ComboBoxItem Content="Decrypt"/>
                                </ComboBox>
                            </StackPanel>

                            <StackPanel Grid.Column="2">
                                <Label Content="Content type"/>
                                <ComboBox
                                    x:Name="cmbTarget"
                                    Style="{StaticResource ModernComboBox}"
                                    SelectedIndex="0">
                                    <ComboBoxItem Tag="string" Content="Single value"/>
                                    <ComboBoxItem Tag="file" Content="Property values in file"/>
                                    <ComboBoxItem Tag="file-level" Content="Entire file contents"/>
                                </ComboBox>
                            </StackPanel>

                            <StackPanel Grid.Column="4">
                                <Label Content="Algorithm"/>
                                <ComboBox
                                    x:Name="cmbAlgorithm"
                                    Style="{StaticResource ModernComboBox}"
                                    SelectedIndex="0">
                                    <ComboBoxItem Content="AES"/>
                                    <ComboBoxItem Content="Blowfish"/>
                                    <ComboBoxItem Content="DES"/>
                                    <ComboBoxItem Content="DESede"/>
                                    <ComboBoxItem Content="RC2"/>
                                    <ComboBoxItem Content="RCA"/>
                                    <ComboBoxItem Content="Camellia"/>
                                    <ComboBoxItem Content="CAST5"/>
                                    <ComboBoxItem Content="CAST6"/>
                                    <ComboBoxItem Content="Noekeon"/>
                                    <ComboBoxItem Content="Rijndael"/>
                                    <ComboBoxItem Content="SEED"/>
                                    <ComboBoxItem Content="Serpent"/>
                                    <ComboBoxItem Content="Skipjack"/>
                                    <ComboBoxItem Content="TEA"/>
                                    <ComboBoxItem Content="Twofish"/>
                                    <ComboBoxItem Content="XTEA"/>
                                    <ComboBoxItem Content="RC5"/>
                                    <ComboBoxItem Content="RC6"/>
                                </ComboBox>
                            </StackPanel>

                            <StackPanel Grid.Column="6">
                                <Label Content="Mode"/>
                                <ComboBox
                                    x:Name="cmbEncryptionMode"
                                    Style="{StaticResource ModernComboBox}"
                                    SelectedIndex="0">
                                    <ComboBoxItem Content="CBC"/>
                                    <ComboBoxItem Content="CFB"/>
                                    <ComboBoxItem Content="ECB"/>
                                    <ComboBoxItem Content="OFB"/>
                                </ComboBox>
                            </StackPanel>

                            <StackPanel Grid.Column="8" VerticalAlignment="Bottom">
                                <CheckBox
                                    x:Name="chkRandomIV"
                                    Content="Random IV"
                                    FontSize="12"
                                    Margin="0,0,0,11"/>
                            </StackPanel>
                        </Grid>

                        <Border
                            Grid.Row="4"
                            Background="#F7FAFD"
                            BorderBrush="#E0EAF4"
                            BorderThickness="1"
                            CornerRadius="7"
                            Padding="10,7">

                            <TextBlock
                                x:Name="lblConfigurationHint"
                                Text="Single value: encrypt or decrypt one password, token, API key, or other secret."
                                FontSize="11"
                                Foreground="#52657A"
                                TextWrapping="Wrap"/>
                        </Border>
                    </Grid>
                </Border>

                <!-- Encryption Key -->
                <Border Grid.Row="2" Style="{StaticResource CardStyle}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="110"/>
                        </Grid.ColumnDefinitions>

                        <StackPanel>
                            <Label Content="Encryption key"/>
                            <Grid>
                                <PasswordBox x:Name="txtKeyPassword"/>
                                <TextBox x:Name="txtKeyVisible" Visibility="Collapsed"/>
                            </Grid>

                            <TextBlock
                                Text="The key remains only in memory while this application is open."
                                FontSize="10"
                                Foreground="#667085"
                                Margin="0,5,0,0"/>
                        </StackPanel>

                        <CheckBox
                            x:Name="chkShowKey"
                            Grid.Column="1"
                            Content="Show key"
                            HorizontalAlignment="Center"
                            VerticalAlignment="Center"/>
                    </Grid>
                </Border>

                <!-- Input and Result -->
                <Border Grid.Row="4" Style="{StaticResource CardStyle}">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="10"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="16"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="16"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel>
                                <TextBlock
                                    Text="Input and Result"
                                    FontSize="17"
                                    FontWeight="SemiBold"
                                    Foreground="#1D2939"/>

                                <TextBlock
                                    x:Name="lblTargetDescription"
                                    Text="Enter a single value to process."
                                    FontSize="11"
                                    Foreground="#667085"
                                    Margin="0,4,0,0"/>
                            </StackPanel>

                            <Border
                                Grid.Column="1"
                                Background="#F0F7FE"
                                CornerRadius="10"
                                Padding="9,4"
                                VerticalAlignment="Top">

                                <TextBlock
                                    x:Name="lblTargetHint"
                                    Text="Single value"
                                    FontSize="10"
                                    Foreground="#1769AA"/>
                            </Border>
                        </Grid>

                        <!-- Single value input -->
                        <StackPanel
                            x:Name="panelValueMode"
                            Grid.Row="2">

                            <Label Content="Value to encrypt or decrypt"/>

                            <TextBox
                                x:Name="txtSingleValue"
                                Height="88"
                                AcceptsReturn="True"
                                TextWrapping="Wrap"
                                VerticalScrollBarVisibility="Auto"/>
                        </StackPanel>

                        <!-- File input -->
                        <StackPanel
                            x:Name="panelFileMode"
                            Grid.Row="2"
                            Visibility="Collapsed">

                            <Label Content="Input configuration file"/>

                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="10"/>
                                    <ColumnDefinition Width="115"/>
                                </Grid.ColumnDefinitions>

                                <TextBox
                                    x:Name="txtInputFile"
                                    IsReadOnly="True"/>

                                <Button
                                    x:Name="btnBrowseInput"
                                    Grid.Column="2"
                                    Content="Select file..."
                                    Style="{StaticResource SecondaryButton}"/>
                            </Grid>

                            <TextBlock
                                x:Name="txtFileHint"
                                Text="The generated output is shown in the Result area below."
                                FontSize="10"
                                Foreground="#667085"
                                Margin="0,6,0,0"/>
                        </StackPanel>

                        <!-- Action buttons -->
                        <Grid Grid.Row="4">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="10"/>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="10"/>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>

                            <Button
                                x:Name="btnRun"
                                Content="Encrypt"
                                Style="{StaticResource PrimaryButton}"
                                MinWidth="160"/>

                            <Button
                                x:Name="btnClear"
                                Grid.Column="2"
                                Content="Clear"
                                Style="{StaticResource SecondaryButton}"
                                MinWidth="92"/>

                            <Button
                                x:Name="btnClose"
                                Grid.Column="4"
                                Content="Close"
                                Style="{StaticResource SecondaryButton}"
                                MinWidth="92"/>
                        </Grid>

                        <!-- Output result -->
                        <Grid Grid.Row="6">
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="8"/>
                                <RowDefinition Height="185"/>
                            </Grid.RowDefinitions>

                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="8"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>

                                <Label
                                    x:Name="lblResult"
                                    Content="Result"
                                    FontWeight="SemiBold"/>

                                <Button
                                    x:Name="btnExportResult"
                                    Grid.Column="1"
                                    Content="Export result..."
                                    Style="{StaticResource SecondaryButton}"
                                    Padding="12,0"
                                    IsEnabled="False"/>

                                <Button
                                    x:Name="btnCopyResult"
                                    Grid.Column="3"
                                    Content="Copy result"
                                    Style="{StaticResource SecondaryButton}"
                                    Padding="12,0"
                                    IsEnabled="False"/>
                            </Grid>

                            <TextBox
                                x:Name="txtResult"
                                Grid.Row="2"
                                IsReadOnly="True"
                                FontFamily="Consolas"
                                FontSize="12"
                                TextWrapping="Wrap"
                                AcceptsReturn="True"
                                VerticalScrollBarVisibility="Auto"
                                Background="#F8FAFC"/>
                        </Grid>
                    </Grid>
                </Border>
            </Grid>
        </ScrollViewer>

        <!-- Footer -->
        <Border
            Grid.Row="2"
            Background="White"
            BorderBrush="#DFE7F0"
            BorderThickness="1,1,0,0"
            Padding="24,10">

            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <TextBlock
                    x:Name="txtStatusDot"
                    Text="●"
                    Foreground="#16A34A"
                    FontSize="16"
                    VerticalAlignment="Center"/>

                <TextBlock
                    x:Name="lblStatus"
                    Grid.Column="1"
                    Text="Ready."
                    Foreground="#475467"
                    FontSize="12"
                    Margin="8,0,0,0"
                    VerticalAlignment="Center"/>
            </Grid>
        </Border>
    </Grid>
</Window>
'@

# ============================================================
# Find UI Controls
# ============================================================
$xmlReader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($xmlReader)

$cmbOperation      = $window.FindName("cmbOperation")
$cmbTarget         = $window.FindName("cmbTarget")
$cmbAlgorithm      = $window.FindName("cmbAlgorithm")
$cmbEncryptionMode = $window.FindName("cmbEncryptionMode")

$chkRandomIV       = $window.FindName("chkRandomIV")
$chkShowKey        = $window.FindName("chkShowKey")

$txtKeyPassword    = $window.FindName("txtKeyPassword")
$txtKeyVisible     = $window.FindName("txtKeyVisible")

$panelValueMode    = $window.FindName("panelValueMode")
$panelFileMode     = $window.FindName("panelFileMode")

$txtSingleValue    = $window.FindName("txtSingleValue")
$txtInputFile      = $window.FindName("txtInputFile")
$txtFileHint       = $window.FindName("txtFileHint")

$btnBrowseInput    = $window.FindName("btnBrowseInput")

$lblConfigurationHint = $window.FindName("lblConfigurationHint")
$lblTargetDescription = $window.FindName("lblTargetDescription")
$lblTargetHint     = $window.FindName("lblTargetHint")

$lblResult         = $window.FindName("lblResult")
$txtResult         = $window.FindName("txtResult")

$btnRun            = $window.FindName("btnRun")
$btnExportResult   = $window.FindName("btnExportResult")
$btnCopyResult     = $window.FindName("btnCopyResult")
$btnClear          = $window.FindName("btnClear")
$btnClose          = $window.FindName("btnClose")

$txtStatusDot      = $window.FindName("txtStatusDot")
$lblStatus         = $window.FindName("lblStatus")

# ============================================================
# Application State
# ============================================================
$script:SelectedMethod = "string"
$script:LastOutputExtension = ".yaml"

# ============================================================
# Helper Functions
# ============================================================
function Set-Status {
    param(
        [string]$Message,
        [string]$Color = "#475467"
    )

    $lblStatus.Text = $Message

    $brush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($Color)

    $lblStatus.Foreground = $brush
    $txtStatusDot.Foreground = $brush
}

function Get-Operation {
    return $cmbOperation.SelectedItem.Content.ToString().ToLower()
}

function Get-Method {
    return $cmbTarget.SelectedItem.Tag.ToString()
}

function Get-KeyValue {
    if ($txtKeyVisible.Visibility -eq [System.Windows.Visibility]::Visible) {
        return $txtKeyVisible.Text
    }

    return $txtKeyPassword.Password
}

function Update-OperationUI {
    $operation = Get-Operation

    $btnRun.Content = $cmbOperation.SelectedItem.Content.ToString()

    if ($operation -eq "encrypt") {
        $chkRandomIV.IsEnabled = $true
    }
    else {
        $chkRandomIV.IsChecked = $false
        $chkRandomIV.IsEnabled = $false
    }
}

function Update-TargetUI {
    $method = Get-Method

    $script:SelectedMethod = $method

    $txtResult.Clear()
    $btnCopyResult.IsEnabled = $false
    $btnExportResult.IsEnabled = $false

    if ($method -eq "string") {
        $panelValueMode.Visibility = [System.Windows.Visibility]::Visible
        $panelFileMode.Visibility = [System.Windows.Visibility]::Collapsed

        $lblConfigurationHint.Text = "Single value: encrypt or decrypt one password, token, API key, or other secret."
        $lblTargetHint.Text = "Single value"
        $lblTargetDescription.Text = "Enter one password, API key, token, client secret, or other value."
        $lblResult.Content = "Encrypted / decrypted value"
    }

    elseif ($method -eq "file") {
        $panelValueMode.Visibility = [System.Windows.Visibility]::Collapsed
        $panelFileMode.Visibility = [System.Windows.Visibility]::Visible

        $lblConfigurationHint.Text = "Property values in file: preserve the YAML/properties structure while encrypting or decrypting individual values."
        $lblTargetHint.Text = "Property values in file"
        $lblTargetDescription.Text = "Encrypt or decrypt property values while keeping the YAML/properties file structure."
        $txtFileHint.Text = "Generated YAML/properties content appears in the Result area before export."
        $lblResult.Content = "Generated file content"
    }

    elseif ($method -eq "file-level") {
        $panelValueMode.Visibility = [System.Windows.Visibility]::Collapsed
        $panelFileMode.Visibility = [System.Windows.Visibility]::Visible

        $lblConfigurationHint.Text = "Entire file contents: encrypt or decrypt the complete configuration file as one secure block."
        $lblTargetHint.Text = "Entire file contents"
        $lblTargetDescription.Text = "Encrypt or decrypt the complete file as one encrypted block."
        $txtFileHint.Text = "Generated content appears in the Result area before export."
        $lblResult.Content = "Generated file content"
    }

    Update-OperationUI
}

function Get-DefaultExportFileName {
    if (-not [string]::IsNullOrWhiteSpace($txtInputFile.Text)) {
        $sourceFile = $txtInputFile.Text
        $folder = Split-Path -Path $sourceFile -Parent
        $extension = [System.IO.Path]::GetExtension($sourceFile)
        $name = [System.IO.Path]::GetFileNameWithoutExtension($sourceFile)
        $operation = Get-Operation

        if ([string]::IsNullOrWhiteSpace($extension)) {
            $extension = ".yaml"
        }

        return (Join-Path $folder "$name-$operation$extension")
    }

    if ($script:SelectedMethod -eq "string") {
        return "secure-value-result.txt"
    }

    return "secure-file-result$($script:LastOutputExtension)"
}

# ============================================================
# UI Events
# ============================================================
$cmbOperation.Add_SelectionChanged({
    Update-OperationUI
})

$cmbTarget.Add_SelectionChanged({
    Update-TargetUI
})

$chkShowKey.Add_Checked({
    $txtKeyVisible.Text = $txtKeyPassword.Password
    $txtKeyPassword.Visibility = [System.Windows.Visibility]::Collapsed
    $txtKeyVisible.Visibility = [System.Windows.Visibility]::Visible
})

$chkShowKey.Add_Unchecked({
    $txtKeyPassword.Password = $txtKeyVisible.Text
    $txtKeyVisible.Visibility = [System.Windows.Visibility]::Collapsed
    $txtKeyPassword.Visibility = [System.Windows.Visibility]::Visible
})

$btnBrowseInput.Add_Click({
    $dialog = New-Object Microsoft.Win32.OpenFileDialog

    $dialog.Title = "Select Secure Properties Input File"
    $dialog.Filter = "YAML and Properties files (*.yaml;*.yml;*.properties)|*.yaml;*.yml;*.properties|All files (*.*)|*.*"

    if ($dialog.ShowDialog()) {
        $txtInputFile.Text = $dialog.FileName

        $extension = [System.IO.Path]::GetExtension($dialog.FileName)

        if (-not [string]::IsNullOrWhiteSpace($extension)) {
            $script:LastOutputExtension = $extension
        }

        Set-Status "Input file selected. Generated output will appear below." "#15803D"
    }
})

# ============================================================
# Encrypt / Decrypt
# ============================================================
$btnRun.Add_Click({

    $txtResult.Clear()
    $btnCopyResult.IsEnabled = $false
    $btnExportResult.IsEnabled = $false

    $operation = Get-Operation
    $method = $script:SelectedMethod
    $algorithm = $cmbAlgorithm.SelectedItem.Content.ToString().Trim()
    $mode = $cmbEncryptionMode.SelectedItem.Content.ToString().Trim()
    $key = Get-KeyValue

    $temporaryOutputFile = $null

    if ([string]::IsNullOrWhiteSpace($key)) {
        [System.Windows.MessageBox]::Show(
            "Enter the encryption key.",
            "Missing Encryption Key",
            "OK",
            "Warning"
        )
        return
    }

    $toolArguments = @(
        "-cp"
        $JarPath
        "com.mulesoft.tools.SecurePropertiesTool"
    )

    # Single value operation
    if ($method -eq "string") {
        $value = $txtSingleValue.Text

        if ([string]::IsNullOrWhiteSpace($value)) {
            [System.Windows.MessageBox]::Show(
                "Enter a value to encrypt or decrypt.",
                "Missing Value",
                "OK",
                "Warning"
            )
            return
        }

        $toolArguments += @(
            "string"
            $operation
            $algorithm
            $mode
            $key
            $value
        )
    }

    # File or file-level operation
    else {
        $inputFile = $txtInputFile.Text.Trim()

        if ([string]::IsNullOrWhiteSpace($inputFile)) {
            [System.Windows.MessageBox]::Show(
                "Select an input file.",
                "Missing Input File",
                "OK",
                "Warning"
            )
            return
        }

        if (-not (Test-Path -LiteralPath $inputFile -PathType Leaf)) {
            [System.Windows.MessageBox]::Show(
                "The selected input file does not exist:`n`n$inputFile",
                "Input File Not Found",
                "OK",
                "Error"
            )
            return
        }

        $inputExtension = [System.IO.Path]::GetExtension($inputFile)

        if ([string]::IsNullOrWhiteSpace($inputExtension)) {
            $inputExtension = ".yaml"
        }

        $script:LastOutputExtension = $inputExtension

        # MuleSoft requires output-file input for file operations.
        # This application uses a temporary file and previews its output.
        $temporaryOutputFile = Join-Path `
            ([System.IO.Path]::GetTempPath()) `
            ("mule-secure-properties-" + [System.Guid]::NewGuid().ToString() + $inputExtension)

        $toolArguments += @(
            $method
            $operation
            $algorithm
            $mode
            $key
            $inputFile
            $temporaryOutputFile
        )
    }

    if ($operation -eq "encrypt" -and $chkRandomIV.IsChecked) {
        $toolArguments += "--use-random-iv"
    }

    try {
        $window.Cursor = [System.Windows.Input.Cursors]::Wait
        $btnRun.IsEnabled = $false

        Set-Status "Processing..." "#1769AA"

        $outputLines = @(& $JavaExecutable @toolArguments 2>&1)
        $exitCode = $LASTEXITCODE

        $javaOutput = ($outputLines | ForEach-Object {
            $_.ToString()
        }) -join [Environment]::NewLine

        if ($exitCode -ne 0) {
            $txtResult.Text = $javaOutput.Trim()

            Set-Status "Failed. Java returned exit code $exitCode." "#B42318"

            [System.Windows.MessageBox]::Show(
                "The operation failed. Review the Result area for details.",
                "Secure Properties Tool Error",
                "OK",
                "Error"
            )

            return
        }

        # Single value output comes directly from Java.
        if ($method -eq "string") {
            $txtResult.Text = $javaOutput.Trim()
        }

        # File output is loaded from temporary generated output.
        else {
            if (-not (Test-Path -LiteralPath $temporaryOutputFile -PathType Leaf)) {
                $txtResult.Text = $javaOutput.Trim()

                Set-Status "The command completed, but no generated output file was found." "#B42318"

                [System.Windows.MessageBox]::Show(
                    "The command completed but the generated output file was not found.",
                    "Output Not Found",
                    "OK",
                    "Error"
                )

                return
            }

            $generatedContent = Get-Content `
                -LiteralPath $temporaryOutputFile `
                -Raw `
                -ErrorAction Stop

            $txtResult.Text = $generatedContent
        }

        $btnCopyResult.IsEnabled = $true
        $btnExportResult.IsEnabled = $true

        Set-Status "Success. You can copy or export the result below." "#15803D"
    }
    catch {
        $txtResult.Text = $_.Exception.Message

        Set-Status "Unable to run Java or read generated output." "#B42318"

        [System.Windows.MessageBox]::Show(
            "Unable to complete the operation.`n`n$($_.Exception.Message)",
            "Execution Error",
            "OK",
            "Error"
        )
    }
    finally {
        if (
            -not [string]::IsNullOrWhiteSpace($temporaryOutputFile) -and
            (Test-Path -LiteralPath $temporaryOutputFile)
        ) {
            Remove-Item `
                -LiteralPath $temporaryOutputFile `
                -Force `
                -ErrorAction SilentlyContinue
        }

        $window.Cursor = [System.Windows.Input.Cursors]::Arrow
        $btnRun.IsEnabled = $true
    }
})

# ============================================================
# Copy Result
# ============================================================
$btnCopyResult.Add_Click({
    if (-not [string]::IsNullOrWhiteSpace($txtResult.Text)) {
        [System.Windows.Clipboard]::SetText($txtResult.Text)
        Set-Status "Result copied to clipboard." "#15803D"
    }
})

# ============================================================
# Export Result
# ============================================================
$btnExportResult.Add_Click({

    if ([string]::IsNullOrWhiteSpace($txtResult.Text)) {
        [System.Windows.MessageBox]::Show(
            "There is no result available to export.",
            "Nothing to Export",
            "OK",
            "Warning"
        )
        return
    }

    $dialog = New-Object Microsoft.Win32.SaveFileDialog

    $dialog.Title = "Export Secure Properties Result"
    $dialog.Filter = "YAML files (*.yaml)|*.yaml|YML files (*.yml)|*.yml|Properties files (*.properties)|*.properties|Text files (*.txt)|*.txt|All files (*.*)|*.*"
    $dialog.AddExtension = $true
    $dialog.OverwritePrompt = $true
    $dialog.FileName = Get-DefaultExportFileName

    if ($dialog.ShowDialog()) {
        try {
            $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)

            [System.IO.File]::WriteAllText(
                $dialog.FileName,
                $txtResult.Text,
                $utf8WithoutBom
            )

            Set-Status "Result exported: $($dialog.FileName)" "#15803D"
        }
        catch {
            Set-Status "Unable to export result." "#B42318"

            [System.Windows.MessageBox]::Show(
                "Unable to export the result.`n`n$($_.Exception.Message)",
                "Export Error",
                "OK",
                "Error"
            )
        }
    }
})

# ============================================================
# Clear
# ============================================================
$btnClear.Add_Click({
    $txtKeyPassword.Clear()
    $txtKeyVisible.Clear()
    $txtSingleValue.Clear()
    $txtInputFile.Clear()
    $txtResult.Clear()

    $chkRandomIV.IsChecked = $false

    $btnCopyResult.IsEnabled = $false
    $btnExportResult.IsEnabled = $false

    Set-Status "Cleared." "#475467"
})

# ============================================================
# Close
# ============================================================
$btnClose.Add_Click({
    $window.Close()
})

# ============================================================
# Start
# ============================================================
Update-TargetUI
Set-Status "Ready." "#475467"

[void] $window.ShowDialog()
