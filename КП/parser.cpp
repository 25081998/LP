#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

typedef struct _People {
    string id;
    string name; 
} People;

typedef struct _Family {
    vector<string> parents;
    vector<string> child;
} Family;

typedef struct _Result {
    string chid;
    string parent;
} Result;

string find(vector<People> &people, string id) 
{
    for (int i = 0; i < people.size(); i++) {
        if (people[i].id == id)
            return people[i].name;
    }
    return "FAIL";
}

int main(int argc, char* argv[])
{   
    ifstream file;
    if (argc == 2)
        file.open(argv[1]);
    else {
        cout << "Укажите путь к файлу" << endl;
        return 0;
    }
    vector<string> data;
    vector<People> people;
    vector<Family> families;
    vector<People> males;
    vector<People> females;    
    int i=0;
    int j=0;
    int num=0;
    while (!file.eof()) {
        string s;
        file >> s;
        data.push_back(s);
        if (data[i] == "INDI") {
            People men;
            men.id = data[i - 1];
            while (!file.eof()) {
                string s1;
                file >> s1;
                data.push_back(s1);
                if (data[i + 1] == "NAME") {
                    file >> s1;
                    men.name = s1;
                    people.push_back(men);
					i++;
                    break;
                }
                i++;
            }
            cout << people[j].id << " " << people[j].name << endl;
            j++;
        }
        else {
            if (data[i] == "FAM") {
                Family guys;
                while (!file.eof()){
                    string s2;
                    file >> s2;
                    data.push_back(s2);
                    if (data[i + 1] == "HUSB" || data[i + 1] == "WIFE") {
                        file >> s2;
                        guys.parents.push_back(s2);
                    }
                    if (data[i + 1] == "CHIL") {
                        file >> s2;
                        guys.child.push_back(s2);
                    }
                    if (data[i + 1] == "_UID") {
                        families.push_back(guys);
                        i++;
                        break;
                    }
                    i++;
                }
                cout << endl << "Parents:" << endl;
                for (int k = 0; k < families[num].parents.size(); k++) {
                    cout << families[num].parents[k] << endl;
                }
                cout << "Children:" << endl;
                for (int k = 0; k < families[num].child.size(); k++) {
                    cout << families[num].child[k] << endl;
                }
                ++num;
            }
        }
        i++;
    }
    data.clear();
    file.close();
    file.open(argv[1]);
    i = 0;
    while (!file.eof()) {
        string s;
        file >> s;
        data.push_back(s);
        if (data[i] == "M") {
            People men1;
            int j = i;
            while (data[j - 1] != "NAME") {
            	j--;
            }
			men1.name = data[j];
            males.push_back(men1);
         }
         else if (data[i] == "F") {
            People men1;
            int j = i;
            while (data[j - 1] != "NAME") {
            	j--;
            }
			men1.name = data[j];
            females.push_back(men1);
         }
         i++;
    }
    data.clear();
    file.close();
    ofstream fout;
    fout.open("outFile.txt");
    vector<Result> result;
    for (int i = 0; i < families.size(); i++) {
        for (int j = 0; j < families[i].child.size(); j++) {
            for (int k = 0; k < families[i].parents.size(); k++) {
                fout << "child(" << find(people, families[i].child[j]) << ", " << find(people, families[i].parents[k]) << ")" << endl;
            }
        }
    }
    for (int i = 0; i < females.size(); i++){
    	fout << "female(" << females[i].name << ")" << endl;
    }
    for (int i = 0; i < males.size(); i++){
    	fout << "male(" << males[i].name << ")" << endl;
    }
    return 0;
}
