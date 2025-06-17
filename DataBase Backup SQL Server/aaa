# 📦 How to Upload (Restore) a Backup Database into SQL Server

This guide explains how to restore a `.bak` (backup) database file into Microsoft SQL Server using **SQL Server Management Studio (SSMS)**.

---

## 🛠️ Requirements

- Microsoft SQL Server installed
- SQL Server Management Studio (SSMS)
- A `.bak` file (database backup)

---

## 🔄 Steps to Restore a Backup Database

### 1. Open SSMS
- Launch **SQL Server Management Studio**.
- Connect to your SQL Server instance.

---

### 2. Restore the Database
1. In the **Object Explorer**, right-click on the **Databases** folder.
2. Select **Restore Database…**

---

### 3. Select the Backup File
1. Under **Source**, select **Device** and click the `...` button.
2. Click **Add**, then locate and select your `.bak` file from your system.
3. Click **OK** to return to the main window.

---

### 4. Choose a Database Name
- In the **Destination** section, you can enter a **new name** for the database if you want to restore it as a different database.

---

### 5. Options (Optional but Recommended)
1. Go to the **Files** tab (on the left).
2. Check the restore paths for data (`.mdf`) and log (`.ldf`) files.
   - You can change the file paths if needed to avoid overwriting an existing database.

---

### 6. Click "OK" to Restore
- SSMS will process the restore.
- After it finishes, you'll see a success message.

---

## ✅ Verify the Restore
- In Object Explorer, expand the **Databases** section.
- Your restored database should now appear there.
- Expand it to view tables, stored procedures, views, etc.

---

## 🧼 Optional Cleanup
If you’ve overwritten an existing database or have multiple versions, consider:
- Renaming older databases.
- Deleting unused backups or databases to save space.

---

## 🧠 Tips

- Make sure the `.bak` file is not in use by another program.
- If restoring fails, check **permissions** on the `.bak` file.
- Ensure **SQL Server user** has access to the folder containing the `.bak`.

